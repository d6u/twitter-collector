var env = require('../../dev-stage/env.json');
for (var e in env) {
  process.env[e] = env[e];
}

var T = require('../app/lib/twitter.js')();
var screenNames = require('./data.json');

T.get('users/lookup', {screen_name: screenNames.join(',')}, function(err, data, res) {
  console.log(data.map(function(d) {
    return d.id_str;
  }).join(','));
});
