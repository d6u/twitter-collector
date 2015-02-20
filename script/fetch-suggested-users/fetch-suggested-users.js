'use strict';

var env = process.env;

var fs = require('fs');

var Twit = require('twit');

var T = new Twit({
  consumer_key:        'KTJsDCW16m4FmzODN66apbM3s',
  consumer_secret:     'Q0MYQEMRoRei7MtRf3CDAFeBy0nxKLIvzhVvHFjrB5YKHXi2UC',
  access_token:        '322847841-mBxkxDQBoFj7wYDsGmu8GPGQiC2fRT9xP4cGbaWv',
  access_token_secret: 'boDX6qJw4SIOnwBUqDJ2aIwt2mcb1L3tGXx0UgASlT6mT'
});

var cats = require('./suggested-categories.json');

fs.readdir('./script/fetch-suggested-users/data', function (err, files) {
  if (err) {
    console.error(err);
  } else {
    var i = 0;

    (function fetchUsers() {
      if (i === cats.length) return;

      var cat = cats[i];

      if (files.indexOf(cat.slug + '.json') > -1) {
        i += 1;
        setImmediate(fetchUsers);
      } else {

        T.get('users/suggestions/' + cat.slug, function (err, data, response) {
          if (err) {
            console.error(err);
          } else {
            var fileName = './script/fetch-suggested-users/data/' + cat.slug + '.json';
            fs.writeFile(fileName, JSON.stringify(data), function (err) {
              if (err) {
                console.error(err);
              } else {
                i += 1;
                setImmediate(fetchUsers);
              }
            });
          }
        });

      }
    }());
  }
});
