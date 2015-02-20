var async = require('async');
var knex = require('knex')({
  client: 'pg',
  connection: 'postgres://postgres@localhost:10001/postgres'
});

var TIME_INTERVAL = 1000 * 60 * 30;

var ids = [
  535472323302682600,
  535826771783192600,
  536729769631842300
];

knex.select('id', 'created_at')
  .from('tweets')
  .where('id', 536729769631842300)
  .then(function (rows) {
    var id = rows[0].id;
    var start = rows[0].created_at.getTime();

    return knex
      .select('created_at')
      .from('tweets')
      .where({'retweeted_status_id': id})
      .orderBy('id', 'ASC')
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

        knex
          .select('id', 'time')
          .from('retweet_count_at_time')
          .where('tweet_id', id)
          .andWhere('count', '<>', '0')
          .orderBy('time', 'ASC')
          .then(function (rows) {
            async.eachSeries(rows, getUserCounterForTweet(id), function () {
              console.log('finish');
            });
          });

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
      });
  });
