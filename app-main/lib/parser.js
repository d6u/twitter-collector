'use strict';

var IDS = require('./ids.json');

var USER_COLUMNS = [
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

var TWEET_COLUMNS = [
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
  'category'
];

function parseUser(obj) {
  var arr = {};
  USER_COLUMNS.forEach(function (column) {
    arr[column] = obj[column];
  });
  arr['tracked_user'] = !!IDS[obj.id];
  arr['has_url']      = obj['url'] != null;
  return arr;
}

function parseTweet(tweet, user) {
  var arr = {};
  TWEET_COLUMNS.forEach(function (column) {
    arr[column] = tweet[column];
  });

  arr['user_id'] = tweet['user']['id'];
  if (tweet['retweeted_status'] != null) {
    arr['retweeted_status_id'] = tweet.retweeted_status.id;
  }

  arr['created_by_tracked_user'] = !!IDS[user.id];

  if (tweet.geo != null) {
    arr['geo_longitude'] = tweet.geo.coordinates[0];
    arr['geo_longitude'] = tweet.geo.coordinates[1];
  }

  if (tweet.entities != null) {
    arr['has_hashtags']      = !!tweet.entities.hashtags.length;
    arr['has_trends']        = !!tweet.entities.trends.length;
    arr['has_urls']          = !!tweet.entities.urls.length;
    arr['has_user_mentions'] = !!tweet.entities.user_mentions.length;
    arr['has_symbols']       = !!tweet.entities.symbols.length;
  } else {
    arr['has_hashtags']      = false;
    arr['has_trends']        = false;
    arr['has_urls']          = false;
    arr['has_user_mentions'] = false;
    arr['has_symbols']       = false;
  }

  if (tweet.extended_entities != null) {
    arr['has_photo'] = !!tweet.extended_entities.media.length;
  } else {
    arr['has_photo'] = false;
  }

  arr['user_ss_location']       = user.location;
  arr['user_ss_follower_count'] = user.followers_count;
  arr['user_ss_friends_count']  = user.friends_count;
  arr['user_ss_listed_count']   = user.listed_count;
  arr['user_ss_statuses_count'] = user.statuses_count;
  arr['user_ss_utc_offset']     = user.utc_offset;
  arr['user_ss_time_zone']      = user.time_zone;

  arr['category'] = JSON.stringify(IDS[user.id]);

  return arr;
}

module.exports = {
  parseUser:  parseUser,
  parseTweet: parseTweet
};
