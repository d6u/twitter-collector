var cluster = require('cluster');
var async = require('async');
var knex = require('knex')({
  client: 'pg',
  connection: 'postgres://postgres@localhost:10001/postgres'
});
var numCPUs = require('os').cpus().length;

function dashToUnderscore(word) {
  return word.replace(/-/g, '_');
}

function createUpdateObj(category) {
  var obj = {};
  for (var i = 0; i < category.length; i++) {
    obj[dashToUnderscore(category[i])] = true;
  }
  return obj;
}

var i = 0;

knex.select('id', 'category')
  .from('original_tweets')
  .then(function (rows) {
    async.eachSeries(rows, function (row, cb) {
      console.log(i, i / rows.length);
      i += 1;
      knex('original_tweets')
        .update(createUpdateObj(row.category))
        .where('id', row.id)
        .then(function () {
          cb();
        });
    }, function () {
      process.exit(0);
    });
  });
