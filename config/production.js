var _ = require('lodash');

var config = {
  env: {
    "NODE_ENV": "production",
    "TWITTER_CONSUMER_KEY": "xxx",
    "TWITTER_CONSUMER_SECRET": "xxx",
    "TWITTER_ACCESS_TOKEN": "xxx",
    "TWITTER_ACCESS_TOKEN_SECRET": "xxx"
  },
  key: {
    "logentries": "xxx"
  }
};

var local = {};
try {
  // Do this without specifying file name so this can be copied to other files
  local = require('../config-local/' + path.basename(__filename, '.js'));
} catch (err) {
  // Swallow `MODULE_NOT_FOUND` error
}
module.exports = _.merge({}, config, local);
