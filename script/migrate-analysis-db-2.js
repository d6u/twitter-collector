'use strict';

var pg = require('pg').native;
var pgConStr = "postgres://postgres@localhost/postgres";

pg.connect(pgConStr, function(err, client, done) {
  if (err) throw err;
  console.log('pg connected');

  client.query(
    'SELECT id, geo, entities, extended_entities FROM original_tweets WHERE dead_time is not null',
    function (err, result) {
      if (err) console.error(err);

      var i = 0, r, arr, l = result.rows.length;

      (function update() {
        r = result.rows[i];

        arr = [];
        arr[0] = r['geo'] != null ? r['geo']['coordinates'][0] : null;
        arr[1] = r['geo'] != null ? r['geo']['coordinates'][1] : null;
        if (r['entities'] != null) {
          arr[2] = r['entities']['hashtags'].length === 0 ? false : true;
          arr[3] = r['entities']['trends'].length   === 0 ? false : true;
          arr[4] = r['entities']['urls'].length     === 0 ? false : true;
          arr[5] = r['entities']['user_mentions'].length === 0 ? false : true;
          arr[6] = r['entities']['symbols'].length  === 0 ? false : true;
        } else {
          arr[2] = false;
          arr[3] = false;
          arr[4] = false;
          arr[5] = false;
          arr[6] = false;
        }
        if (r['extended_entities'] != null) {
          var hasPhoto = false;
          for (var j = 0; j < r['extended_entities']['media'].length; j++) {
            if (r['extended_entities']['media'][j]['type'] === 'photo') {
              hasPhoto = true;
            } else {
              console.log('unexpected extended_entities type: '+
                r['extended_entities']['media'][j]['type']);
            }
          }
          arr[7] = hasPhoto;
        } else {
          arr[7] = false;
        }

        arr[8] = r.id;

        client.query('UPDATE original_tweets SET geo_lon = $1, geo_lat = $2, has_hashtags = $3, has_trends = $4, has_urls = $5, has_user_mentions = $6, has_symbols = $7, has_photo = $8 WHERE id = $9', arr, function (err, result) {
          if (err) console.error(err);

          i += 1;
          console.log('processed %d', i);
          if (i === l) {
            process.exit(0);
          } else {
            update();
          }
        })
      }());
    }
  );
});
