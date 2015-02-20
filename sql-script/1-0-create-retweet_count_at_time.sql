DROP INDEX IF EXISTS retweet_count_at_time_tweet_id_index;
DROP INDEX IF EXISTS retweet_count_at_time_time_index;

DROP TABLE IF EXISTS retweet_count_at_time;

CREATE TABLE retweet_count_at_time (
  id         BIGSERIAL PRIMARY KEY,
  tweet_id   BIGINT NOT NULL,
  time       TIMESTAMP WITH TIME ZONE NOT NULL,
  count      INT NOT NULL,
  accu_count INT NOT NULL
);

CREATE INDEX retweet_count_at_time_tweet_id_index ON retweet_count_at_time (tweet_id);
CREATE INDEX retweet_count_at_time_time_index ON retweet_count_at_time (time);
