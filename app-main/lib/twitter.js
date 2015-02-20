var env = process.env;

var Twit = require('twit');

var T = new Twit({
  consumer_key:        env.TWITTER_CONSUMER_KEY,
  consumer_secret:     env.TWITTER_CONSUMER_SECRET,
  access_token:        env.TWITTER_ACCESS_TOKEN,
  access_token_secret: env.TWITTER_ACCESS_TOKEN_SECRET
});

module.exports = function () {
  return T;
};
