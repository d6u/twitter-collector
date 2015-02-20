'use strict';

var env = process.env;

var IDS = require('./lib/ids.json');

var pgConStr = env.NODE_ENV === 'production' ?
  'postgres://postgres@postgres/postgres' :
  'postgres://postgres@localhost/postgres';

var knex = require('knex')({
  client: 'pg',
  connection: pgConStr
});

var T          = require('./lib/twitter')()
  , parser     = require('./lib/parser')
  , parseUser  = parser.parseUser
  , parseTweet = parser.parseTweet
  , logger     = require('./lib/logger')
  , prettyJSON = logger.prettyJSON
  , debug      = logger.debug
  , info       = logger.info
  , warn       = logger.warn
  , error      = logger.error;

var stream, startTime, userCount = 0, tweetCount = 0;

stream = T.stream('statuses/filter', {follow: Object.keys(IDS)});

stream.on('connect', function (request) {
  info('stream connected');
});

stream.on('tweet', function (tweet) {
  processData(tweet);
});

stream.on('limit', function (limitMessage) {
  warn('stream limit %j', limitMessage);
});

stream.on('disconnect', function () {
  error('stream disconnected');
  stream.start();
});

stream.on('reconnect', function (request, response, connectInterval) {
  warn('reconnect connectInterval: %d', connectInterval);
});

stream.on('warning', function (warning) {
  warn('stream warning %j', warning);
});

stream.on('error', function (err) {
  error('stream error %j', err);
});

function processData(tweet) {
  var isTrackedUser = !!IDS[tweet.user.id];
  if (!tweet.retweeted_status && !isTrackedUser) return;

  var user     = tweet.user
    , userObj  = parseUser(user)
    , tweetObj = parseTweet(tweet, user);

	knex('users')
  .update(userObj)
  .where({id: userObj.id})
  .then(function (rowCount) {
    if (rowCount === 0) {
      return knex('users').insert(userObj).then(function () {
        userCount++;

        if (userCount % 1000 === 0) {
          info('inserted '+userCount+' users since app start');
        }
      });
    }
  })
  .catch(function (err) {
    if (err.code !== '23505') { // duplicate pk error
      warn('error inserting - %j, %j, %j', err, userObj, tweetObj);
    }
  });

  knex('tweets')
  .insert(tweetObj)
  .then(function () {
    tweetCount++;

    if (tweetCount % 1000 === 0) {
      info('inserted '+tweetCount+' tweets since app start');
    }
  })
  .catch(function (err) {
    if (err.code !== '23505') { // duplicate pk error
      warn('error inserting - %j, %j, %j', err, userObj, tweetObj);
    }
  });
}

process.on('uncaughtException', function (err) {
  fatal('uncaughtException %j', err);
  throw err;
});

process.on('exit', function () {
  if (stream != null) {
    stream.stop();
  }
  warn('About to exit');
});

process.on('SIGINT', function () {
	if (stream != null) {
    stream.stop();
  }
  warn('received SIGINT');
  process.exit(1);
});
