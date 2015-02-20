// count-exposed-user-per-interval.js
//

var TIME_INTERVAL = 1000 * 60;

var cluster = require('cluster');
var async = require('async');
var knex = require('knex')({
  client: 'pg',
  connection: 'postgres://postgres@localhost:10001/postgres'
});
var numCPUs = require('os').cpus().length;

if (cluster.isMaster) {

  // Fetch all original tweet id that need to count exposed users
  //
  var i = 0;

  knex
    .select()
    .distinct('tweet_id')
    .from('retweet_count_at_time')
    .map(function (rows) {
      return rows.tweet_id;
    })
    .then(function (tweetIds) {
      // Fork workers
      //
      var j = 0;

      for (; i < numCPUs; i++) {
        (function () {
          var worker = cluster.fork();
          worker.on('message', function (msg) {
            if (msg === 'done') {
              if (j < tweetIds.length) {
                console.log(j, j / tweetIds.length);
                worker.send(tweetIds[j]);
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

  function countUserForTweet(id, cb) {
    knex
      .select('id', 'time')
      .from('retweet_count_at_time')
      .where('tweet_id', id)
      .andWhere('count', '<>', '0')
      .orderBy('time', 'ASC')
      .then(function (rows) {
        async.eachSeries(rows, getUserCounterForTweet(id), cb);
      });
  }

  function getUserCounterForTweet(id) {
    return function (row, cb) {
      knex
        .sum('user_ss_follower_count')
        .from('tweets')
        .where('retweeted_status_id', id)
        .andWhere('created_at', '>', row.time)
        .andWhere('created_at', '<=', new Date(row.time.getTime() + TIME_INTERVAL))
        .then(function (result) {
          return knex('retweet_count_at_time')
            .update('exposed_user_count', result[0].sum)
            .where('id', row.id);
        })
        .then(function () {
          cb();
        });
    }
  }

  process.on('message', function (id) {
    countUserForTweet(id, function () {
      process.send('done');
    });
  });

  process.send('done'); // kick off the first job order
}
