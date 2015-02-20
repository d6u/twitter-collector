ALTER TABLE retweet_count_at_time
  DROP COLUMN IF EXISTS exposed_user_count;

ALTER TABLE retweet_count_at_time
  ADD COLUMN exposed_user_count INT DEFAULT 0;

CREATE INDEX retweet_count_at_time_count_index ON retweet_count_at_time(count);
