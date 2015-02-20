'use strict';

var expect = require('chai').expect
  , pg     = require('pg').native;

var pgConStrNew = 'postgres://postgres@localhost/postgres'
  , pgConStrOld = 'postgres://postgres@localhost:10001/postgres';

var userAttr = [
  'id',
  'tracked_user',
  'name',
  'screen_name',
  'location',
  'description',
  'verified',
  'followers_count',
  'friends_count',
  'listed_count',
  'statuses_count',
  'created_at',
  'utc_offset',
  'time_zone',
  'lang',
  'has_url'
];

var tweetAttr = [
  'id',
  'user_id',
  'created_by_tracked_user',
  'created_at',
  'text',
  'source',
  'in_reply_to_status_id',
  'in_reply_to_user_id',
  'in_reply_to_screen_name',
  'place',
  'retweet_count',
  'favorite_count',
  'possibly_sensitive',
  'filter_level',
  'lang',
  'retweeted_status_id',
  'entities',
  'extended_entities',
  'geo_longitude',
  'geo_latitude',
  'has_hashtags',
  'has_trends',
  'has_urls',
  'has_user_mentions',
  'has_symbols',
  'has_photo',
  'user_ss_location',
  'user_ss_follower_count',
  'user_ss_friends_count',
  'user_ss_listed_count',
  'user_ss_statuses_count',
  'user_ss_utc_offset',
  'user_ss_time_zone',
];

function convertUser(obj) {
  var arr = [];
  userAttr.each(function (attr) {
    arr.push(obj[attr]);
  });
  arr[userAttr.indexOf('has_url')] = obj['url'] != null;
  return arr;
}

function convertTweet(obj) {
  var arr = [];
  tweetAttr.each(function (attr) {
    arr.push(obj[attr]);
  });
  // arr[tweetAttr.indexOf('has_url')] = obj['url'] != null;
  return arr;
}

describe('PostgreSQL database structure', function () {
  describe('tweets table', function () {

    it('should successfully contains existing data', function (done) {

      pg.connect(pgConStrNew, function (err, newClient, dbDone) {
        expect(err).null;
        pg.connect(pgConStrOld, function (err, oldClient, dbDone) {
          expect(err).null;

          var query = oldClient.query('SELECT * FROM tweets LIMIT 10000');

          query.on('row', function (row) {
            var insertStr = 'INSERT INTO tweets SELECT $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13 $14 $15 $16 $17';

            newClient.query(insertStr, [], function (err, result) {
              expect(err).null;
            });
          });

          query.on('error', function (err) {
            expect(err).null;
          });

          query.on('end', function (result) {
            expect(result.rowCount).eql(10000);
          });

        });
      });

    });
  });

  describe('users table', function () {

  });
});
