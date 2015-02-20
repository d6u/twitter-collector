// calc-dead-time.js
//

var TIME_INTERVAL = 1000 * 60;
var NUM_INTERVAL_PER_DAY = 1000 * 60 * 60 * 24 / TIME_INTERVAL;

var cluster = require('cluster');
var async = require('async');
var knex = require('knex')({
  client: 'pg',
  connection: 'postgres://postgres@localhost:10001/postgres'
});
var numCPUs = require('os').cpus().length;

if (cluster.isMaster) {

  // Fetch all original tweet id that need to calc dead time
  //
  var i = 0;

  knex
    .select('id')
    .from('original_tweets')
    .orderBy('id', 'ASC')
    .map(function (row) {
      return row.id;
    })
    .then(function (ids) {
      // async.eachSeries(ids, calcDeadTime);

      // Fork workers
      //
      var j = 0;

      for (; i < numCPUs; i++) {
        (function () {
          var worker = cluster.fork();
          worker.on('message', function (msg) {
            if (msg === 'done') {
              if (j < ids.length) {
                console.log(j, j / ids.length);
                worker.send(ids[j]);
                j += 1;
              } else {
                worker.kill();
              }
            }
          });
        })();
      }
    });

  cluster.on('exit', function(worker, code, signal) {
    console.log('no more jobs for worker ' + worker.process.pid + ' and it died');
    i -= 1;
    if (i === 0) {
      process.exit(0);
    }
  });

} else {
  // Worker
  //

  function calcDeadTime(id, cb) {
    knex
      .select('accu_count')
      .from('retweet_count_at_time')
      .where('tweet_id', id)
      .orderBy('time', 'ASC')
      .then(function (rows) {
        var i = 0;
        while (rows[i + NUM_INTERVAL_PER_DAY]) {
          var beforeCount = rows[i].accu_count;
          var totalCount = rows[i + NUM_INTERVAL_PER_DAY].accu_count;
          if (isDead(beforeCount, totalCount)) {
            return [i + 1, beforeCount];
          }
          i += 1;
        }
      })
      .then(function (result) {
        if (result) {
          return knex('original_tweets')
            .update({
              'dead_time': result[0],
              'dead_time_total_retweet': result[1]
            })
            .where('id', id);
        }
      })
      .then(function () {
        cb();
      });
  }

  function isDead(beforeCount, totalCount) {
    return (totalCount - beforeCount) < (beforeCount > 400 ? beforeCount * 0.01 : 4);
  }

  process.on('message', function (id) {
    calcDeadTime(id, function () {
      process.send('done');
    });
  });

  process.send('done'); // kick off the first job order
}
