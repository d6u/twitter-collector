'use strict';

var USER_COLUMNS = [
  'id',
  'id_str',
  'name',
  'screen_name',
  'location',
  'url',
  'description',
  'protected',
  'verified',
  'followers_count',
  'friends_count',
  'listed_count',
  'statuses_count',
  'created_at',
  'utc_offset',
  'time_zone',
  'lang',
  'contributors_enabled',
  'is_translator',
  'profile_background_color',
  'profile_background_image_url',
  'profile_background_image_url_https',
  'profile_background_tile',
  'profile_link_color',
  'profile_sidebar_border_color',
  'profile_sidebar_fill_color',
  'profile_text_color',
  'profile_use_background_image',
  'profile_image_url',
  'profile_image_url_https',
  'profile_banner_url',
  'default_profile',
  'default_profile_image'
];

var TWEET_COLUMNS = [
  'id',
  'id_str',
  'created_at',
  'text',
  'source',
  'truncated',
  'in_reply_to_status_id',
  'in_reply_to_status_id_str',
  'in_reply_to_user_id',
  'in_reply_to_user_id_str',
  'in_reply_to_screen_name',
  'user_id',
  'user_id_str',
  'geo',
  'coordinates',
  'place',
  'retweet_count',
  'favorite_count',
  'entities',
  'favorited',
  'retweeted',
  'possibly_sensitive',
  'filter_level',
  'lang',
  'timestamp_ms',
  'retweeted_status_id',
  'retweeted_status_id_str',
  'extended_entities'
];

function parseUser(user) {
  var arr = [];
  for (var i = 0; i < USER_COLUMNS.length; i++) {
    arr[i] = user[USER_COLUMNS[i]];
  }
  return arr;
}

function parseTweet(tweet) {
  var arr = [];
  for (var i = 0; i < TWEET_COLUMNS.length; i++) {
    arr[i] = tweet[TWEET_COLUMNS[i]];
  }
  arr[11] = tweet.user.id;
  arr[12] = tweet.user.id_str;
  if (tweet.retweeted_status != null) {
    arr[25] = tweet.retweeted_status.id;
    arr[26] = tweet.retweeted_status.id_str;
  }
  return arr;
}

var pg = require('pg');
var pgConStr = 'postgres://postgres@localhost/postgres';

var MongoClient = require('mongodb').MongoClient;
var mongoConUrl = 'mongodb://localhost/twitter';

MongoClient.connect(mongoConUrl, function(err, db) {
  if (err) throw err;

  pg.connect(pgConStr, function(err, client, done) {
    if (err) throw err;

    var cursor = db.collection('tweets').find();

    var i = 0;

    function queryNext() {
      cursor.next(function(err, tweet) {
        if (err) throw err;
        if (tweet === null) {
          done();
          process.exit(0);
        }

        i++;
        if (i % 1000 === 0) console.log('loaded ' + i);

        var ops = 0;
        client.query('INSERT INTO users VALUES ($1, $2, $3, $4, $5, $6, $7 ,$8 ,'+
          '$9 ,$10 ,$11 ,$12 ,$13 ,$14 ,$15 ,$16 ,$17 ,$18 ,$19 ,$20 ,$21 ,$22 ,'+
          '$23 ,$24 ,$25 ,$26 ,$27 ,$28 ,$29 ,$30 ,$31 ,$32 ,$33)',
        parseUser(tweet.user),
        function(err, result) {
          // if (err) console.error(err.detail);
          ops++;
          if (ops === 2) {
            queryNext();
          }
        });

        client.query('INSERT INTO tweets VALUES ($1, $2, $3, $4, $5, $6, $7, '+
          '$8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, '+
          '$22, $23, $24, $25, $26, $27, $28)',
        parseTweet(tweet),
        function(err, result) {
          if (err) console.error(err.detail);
          ops++;
          if (ops === 2) {
            queryNext();
          }
        });

      });
    }

    queryNext();
  });
});
