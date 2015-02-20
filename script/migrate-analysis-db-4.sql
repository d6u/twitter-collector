-- ALTER TABLE original_tweets
-- ADD COLUMN dead_min_since_create           bigint,
-- ADD COLUMN user_created_at_unix            bigint,
-- ADD COLUMN tweet_created_at_since_midnight bigint;

UPDATE original_tweets t
  SET
  dead_min_since_create = extract('epoch' from t.dead_time - t.created_at) / 60,
  user_created_at_unix  = extract('epoch' from u.created_at),
  tweet_created_at_since_midnight =
    extract('hour' from t.created_at) * 60 + extract('minute' from t.created_at)
  FROM users u
  WHERE t.dead_time is not null AND t.user_id = u.id;
