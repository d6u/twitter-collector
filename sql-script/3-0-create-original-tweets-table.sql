DROP INDEX IF EXISTS original_tweets_user_id_index;
DROP TABLE IF EXISTS original_tweets; -- table

CREATE TABLE original_tweets (
  id                      BIGINT PRIMARY KEY,
  user_id                 BIGINT NOT NULL,
  created_at              TIMESTAMP WITH TIME ZONE,
  text                    TEXT,
  source                  TEXT,
  in_reply_to_status_id   BIGINT,
  in_reply_to_user_id     BIGINT,
  in_reply_to_screen_name TEXT,
  place                   JSON,
  retweet_count           INT,
  favorite_count          INT,
  possibly_sensitive      BOOLEAN,
  filter_level            VARCHAR(20),
  lang                    VARCHAR(10),
  retweeted_status_id     BIGINT,
  entities                JSON,
  extended_entities       JSON,
  -- derived attributes
  geo_longitude           REAL,
  geo_latitude            REAL,
  has_hashtags            BOOLEAN NOT NULL,
  has_trends              BOOLEAN NOT NULL,
  has_urls                BOOLEAN NOT NULL,
  has_user_mentions       BOOLEAN NOT NULL,
  has_symbols             BOOLEAN NOT NULL,
  has_photo               BOOLEAN NOT NULL,
  -- creator info snapshot
  user_ss_location        TEXT,
  user_ss_follower_count  INT NOT NULL,
  user_ss_friends_count   INT NOT NULL,
  user_ss_listed_count    INT NOT NULL,
  user_ss_statuses_count  INT NOT NULL,
  user_ss_utc_offset      INT,
  user_ss_time_zone       TEXT,
  -- category info from Twitter
  category                JSON,
  -- calculated
  dead_time               BIGINT, -- number of min
  dead_time_total_retweet BIGINT
);

CREATE INDEX original_tweets_user_id_index ON original_tweets (user_id);

-- import original tweets

INSERT INTO original_tweets (
  id,
  user_id,
  created_at,
  text,
  source,
  in_reply_to_status_id,
  in_reply_to_user_id,
  in_reply_to_screen_name,
  place,
  retweet_count,
  favorite_count,
  possibly_sensitive,
  filter_level,
  lang,
  retweeted_status_id,
  entities,
  extended_entities,
  geo_longitude,
  geo_latitude,
  has_hashtags,
  has_trends,
  has_urls,
  has_user_mentions,
  has_symbols,
  has_photo,
  user_ss_location,
  user_ss_follower_count,
  user_ss_friends_count,
  user_ss_listed_count,
  user_ss_statuses_count,
  user_ss_utc_offset,
  user_ss_time_zone,
  category)
SELECT id, user_id, created_at, text, source, in_reply_to_status_id, in_reply_to_user_id, in_reply_to_screen_name, place, retweet_count, favorite_count, possibly_sensitive, filter_level, lang, retweeted_status_id, entities, extended_entities, geo_longitude, geo_latitude, has_hashtags, has_trends, has_urls, has_user_mentions, has_symbols, has_photo, user_ss_location, user_ss_follower_count, user_ss_friends_count, user_ss_listed_count, user_ss_statuses_count, user_ss_utc_offset, user_ss_time_zone, category
FROM tweets
WHERE created_by_tracked_user = true;
