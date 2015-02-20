"use strict";

var ID_ARR = ['19923144', '155659213', '300392950', '35936474', '42384760', '23083404', '2557521', '19426551', '344634424', '32765534', '26257166', '17461978', '44409004', '79293791', '21447363', '14230524', '26565946', '100220864', '17919972', '373471064', '27260086', '4101221', '23375688', '27909036', '954590804', '18665800', '18164420', '65525881', '953278568', '1598644159', '126990459', '22411875', '568825492', '40297195', '21237045', '15439395', '90420314', '18713254', '130649891', '6480682', '15485441', '15846407', '15693493', '52551600', '10228272', '10810102', '20015311', '19562228', '14075928', '18948541', '22461427', '5402612', '5988062', '1652541', '759251', '807095', '91478624', '1367531', '742143', '5392522', '783214', '15492359', '50393960', '7144422', '20536157', '1344951', '14885549', '816653', '11518842', '10876852', '15208246', '50940456', '326359913', '14399483', '16193578', '136361303', '158128894', '109702885', '20177423', '47459700'];

function getUnixMin(date) {
  return date.getTime() / 1000 / 60 / 30;
}

var pg = require("pg");
var pgConStr = "postgres://postgres@54.187.57.174:10001/postgres";

pg.connect(pgConStr, function(err, client, done) {
  if (err) throw err;

  console.log("pg connected");

  var tweetId = 525624054108405760;

  client.query("SELECT * FROM tweets WHERE id = $1", [tweetId], function (err, result) {
    if (err) console.error(err);

    var beginTime = Math.ceil(getUnixMin(result.rows[0].created_at));

    client.query("SELECT * FROM tweets WHERE retweeted_status_id = $1 ORDER BY created_at ASC", [tweetId], function (err, result) {
      if (err) console.error(err);
      done();

      var summary = {};
      summary[beginTime] = 0;

      var r;

      for (var i = 0; i < result.rows.length; i++) {
        r = result.rows[i];
        (function testDate() {
          if (getUnixMin(r.created_at) - beginTime < 1) {
            summary[beginTime] += 1;
          } else {
            beginTime += 1;
            summary[beginTime] = 0;
            testDate();
          }
        }());
      }

      console.log(summary);

      process.exit(0);
    });
  });

  // client.query(
  //   "SELECT * "+
  //   "FROM users "+
  //   "WHERE id = 2610198810",
  //   function (err, result) {
  //   console.log(err);
  //   console.log(result.rows);

  //   done();
  //   process.exit(0);
  // });

  // client.query(
  //   "SELECT u.name as user_name, u.screen_name as user_screen_name, t.* "+
  //   "FROM tweets t, users u "+
  //   "WHERE user_id = $1 AND retweeted_status_id is NULL AND user_id = u.id "+
  //   "ORDER BY t.id ASC "+
  //   // "OFFSET 1 "+
  //   "LIMIT 100",
  //   [ID_ARR[0]],
  //   function (err, result) {
  //   if (err) console.error(err);
  //   console.log(result.rows.);

  //   done();
  //   process.exit(0);
  // });
});
