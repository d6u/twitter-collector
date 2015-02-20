-- Users

DROP INDEX IF EXISTS users_tracked_user_index;
DROP INDEX IF EXISTS users_name_index;
DROP INDEX IF EXISTS users_screen_name_index;
DROP TABLE IF EXISTS users; -- table

CREATE TABLE users (
  id              BIGINT PRIMARY KEY,
  tracked_user    BOOLEAN NOT NULL,
  name            TEXT,
  screen_name     TEXT,
  location        TEXT,
  description     TEXT,
  verified        BOOLEAN,
  followers_count INT,
  friends_count   INT,
  listed_count    INT,
  statuses_count  INT,
  created_at      TIMESTAMP WITH TIME ZONE,
  utc_offset      INT,
  time_zone       TEXT,
  lang            VARCHAR(10),
  -- derived attributes
  has_url         BOOLEAN NOT NULL
);

CREATE INDEX users_tracked_user_index ON users (tracked_user);
CREATE INDEX users_name_index         ON users (name);
CREATE INDEX users_screen_name_index  ON users (screen_name);

-- tweets

DROP INDEX IF EXISTS tweets_created_by_tracked_user_index;
DROP INDEX IF EXISTS tweets_created_at_index;
DROP TABLE IF EXISTS tweets; -- table

CREATE TABLE tweets (
  id                      BIGINT PRIMARY KEY,
  user_id                 BIGINT NOT NULL,
  created_by_tracked_user BOOLEAN NOT NULL,
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
  category                JSON
);

CREATE INDEX tweets_created_by_tracked_user_index ON tweets (created_by_tracked_user);
CREATE INDEX tweets_created_at_index              ON tweets (created_at);

-- retweet_count_per_minute

DROP INDEX IF EXISTS retweet_count_per_minute_tweet_id_index;
DROP INDEX IF EXISTS retweet_count_per_minute_start_time_index;
DROP TABLE IF EXISTS retweet_count_per_minute; -- table

CREATE TABLE retweet_count_per_minute (
  id                        BIGSERIAL PRIMARY KEY,
  tweet_id                  BIGINT NOT NULL,
  start_time                TIMESTAMP WITH TIME ZONE NOT NULL,
  count                     INT NOT NULL,
  total_count_since_created INT NOT NULL
);

CREATE INDEX retweet_count_per_minute_tweet_id_index ON retweet_count_per_minute(tweet_id);
CREATE INDEX retweet_count_per_minute_start_time_index ON retweet_count_per_minute (start_time);
