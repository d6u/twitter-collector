'use strict';

var async = require('async');
var knex = require('knex')({
  client: 'pg',
  connection: 'postgres://postgres@localhost:10001/postgres'
});
var ID_DATA = require('../source/app/lib/ids.json');
var ids = Object.keys(ID_DATA);

var TIME_INTERVAL = 1000 * 60;
var count = 0;

var cluster = require('cluster');
var numCPUs = require('os').cpus().length;

if (cluster.isMaster) {
  var j = numCPUs;
  // Fork workers.
  for (var i = 0; i < numCPUs; i++) {
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
      worker.send(ids[i]);
    })();
  }

  cluster.on('exit', function(worker, code, signal) {
    console.log('worker ' + worker.process.pid + ' died');
    i -= 1;
    if (i === 0) {
      process.exit(0);
    }
  });

} else {
  // Worker

  process.on('message', function (id) {

    knex.select('id', 'created_at').from('tweets').where('user_id', id).orderBy('id', 'ASC')
    .then(function (rows) {
      async.eachLimit(rows, 5, function (row, cb) {
        var id = row.id;
        var start = row.created_at.getTime();

        knex.select('created_at').from('tweets').where({'retweeted_status_id': id}).orderBy('id', 'ASC')
        .then(function (rows) {
          var summary = {};
          summary[start] = 0;

          rows.forEach(function (row) {
            (function compare() {
              if (row.created_at.getTime() - start <= TIME_INTERVAL) {
                summary[start] += 1;
              } else {
                start += TIME_INTERVAL;
                summary[start] = 0;
                compare();
              }
            })();
          });

          var totalCounts = {};
          var prevKey;

          return Object.keys(summary).sort().map(function (key) {
            if (prevKey != null) {
              totalCounts[key] = totalCounts[prevKey] + summary[key];
            } else {
              totalCounts[key] = summary[key];
            }
            prevKey = key;

            return {
              tweet_id: id,
              time: new Date(Number(key)),
              count: summary[key],
              accu_count: totalCounts[key]
            };
          });
        })
        .then(function (objs) {
          return knex('retweet_count_at_time').insert(objs);
        })
        .then(function () {
          cb();
        });
      }, function () {
        process.send('done');
      });
    });

  }); // END process.on('message', ...)
}
