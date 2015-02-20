ALTER TABLE original_tweets
  ADD COLUMN created_at_day INT;

UPDATE original_tweets ot
  SET created_at_day = EXTRACT('dow' FROM created_at);
