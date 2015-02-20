var MongoClient = require('mongodb').MongoClient;
var mongoUrl = 'mongodb://localhost/twitter';

MongoClient.connect(mongoUrl, function(err, db) {
  if (err) return console.error(err);

  var collection = db.collection('tweets');
  var summary = {};

  var i = 0;

  collection.find().limit(800).forEach(function(tweet) {

    summarize(tweet.retweeted_status, summary);

  }, function(err) {
    if (err) console.error(err);
    db.close();
    console.log(summary);
  });
});

function summarize(obj, summary) {
  if (summary === undefined) {
    summary = {};
  }

  for (var key in obj) {
    if(obj.hasOwnProperty(key)) {
      if (summary[key] === undefined) {
        summary[key] = {type: []};
      }
      var type = toString.call(obj[key]).replace(/\[object (.+?)\]/, '$1');
      if (summary[key].type.indexOf(type) === -1) {
        summary[key].type.push(type);
      }
    }
  }

  return summary;
}

var toString = Object.prototype.toString;


