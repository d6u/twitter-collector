'use strict';

var fs = require('fs');

var ids = {};

fs.readdir('./script/fetch-suggested-users/data', function (err, files) {
  if (err) {
    console.error(err);
  } else {
    files.forEach(function (file) {
      var data = require('./data/' + file);
      data.users.forEach(function (user) {
        if (ids[user.id] == null) {
          ids[user.id] = [];
        }
        ids[user.id].push(file.replace('.json', ''));
      });
    });

    fs.writeFile('./script/fetch-suggested-users/ids.json', JSON.stringify(ids), function (err) {
      if (err) {
        console.error(err);
      }
    });
  }
});
