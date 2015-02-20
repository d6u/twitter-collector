DROP INDEX IF EXISTS original_tweets_created_at_index;
DROP INDEX IF EXISTS original_tweets_user_id_index;
DROP INDEX IF EXISTS original_tweets_retweeted_status_id_index;

DROP TABLE IF EXISTS original_tweets;

CREATE TABLE original_tweets (
  id bigint primary key,
  id_str varchar(100),
  created_at timestamp with time zone,
  text text,
  source varchar(255),
  truncated boolean,
  in_reply_to_status_id bigint,
  in_reply_to_status_id_str varchar(100),
  in_reply_to_user_id bigint,
  in_reply_to_user_id_str varchar(100),
  in_reply_to_screen_name varchar(255),
  user_id bigint,
  user_id_str varchar(100),
  geo json,
  coordinates json,
  place json,
  retweet_count int,
  favorite_count int,
  entities json,
  favorited boolean,
  retweeted boolean,
  possibly_sensitive boolean,
  filter_level varchar(100),
  lang varchar(100),
  timestamp_ms varchar(100),
  retweeted_status_id bigint,
  retweeted_status_id_str varchar(100),
  extended_entities json,
  dead_time timestamp with time zone,
  dead_time_total_retweet int
);

CREATE INDEX original_tweets_created_at_index ON original_tweets (created_at);
CREATE INDEX original_tweets_user_id_index ON original_tweets (user_id);
CREATE INDEX original_tweets_retweeted_status_id_index ON original_tweets (retweeted_status_id);

-- retweet_count_at_time

DROP INDEX IF EXISTS retweet_count_at_time_tweet_id_index;
DROP INDEX IF EXISTS retweet_count_at_time_time_index;

DROP TABLE IF EXISTS retweet_count_at_time;

CREATE TABLE retweet_count_at_time (
  id bigserial primary key,
  tweet_id bigint NOT NULL,
  time timestamp with time zone NOT NULL,
  count int NOT NULL,
  accu_count int NOT NULL
);

CREATE INDEX retweet_count_at_time_tweet_id_index ON retweet_count_at_time (tweet_id);
CREATE INDEX retweet_count_at_time_time_index ON retweet_count_at_time (time);

-- import original tweets into original_tweets table

INSERT INTO original_tweets
(
  id, id_str, created_at, text, source, truncated, in_reply_to_status_id, in_reply_to_status_id_str, in_reply_to_user_id, in_reply_to_user_id_str, in_reply_to_screen_name, user_id, user_id_str, geo, coordinates, place, retweet_count, favorite_count, entities, favorited, retweeted, possibly_sensitive, filter_level, lang, timestamp_ms, retweeted_status_id, retweeted_status_id_str, extended_entities
)
(
  SELECT * FROM tweets WHERE user_id IN (19923144, 155659213, 300392950, 35936474, 42384760, 23083404, 2557521, 19426551, 344634424, 32765534, 26257166, 17461978, 44409004, 79293791, 21447363, 14230524, 26565946, 100220864, 17919972, 373471064, 27260086, 4101221, 23375688, 27909036, 954590804, 18665800, 18164420, 65525881, 953278568, 1598644159, 126990459, 22411875, 568825492, 40297195, 21237045, 15439395, 90420314, 18713254, 130649891, 6480682, 15485441, 15846407, 15693493, 52551600, 10228272, 10810102, 20015311, 19562228, 14075928, 18948541, 22461427, 5402612, 5988062, 1652541, 759251, 807095, 91478624, 1367531, 742143, 5392522, 783214, 15492359, 50393960, 7144422, 20536157, 1344951, 14885549, 816653, 11518842, 10876852, 15208246, 50940456, 326359913, 14399483, 16193578, 136361303, 158128894, 109702885, 20177423, 47459700) ORDER BY id ASC
);
