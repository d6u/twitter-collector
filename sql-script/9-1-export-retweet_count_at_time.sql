COPY (
  SELECT
    id,
    tweet_id,
    time,
    count,
    accu_count,
    exposed_user_count
  FROM retweet_count_at_time
  WHERE tweet_id = 536729769631842300
  ORDER BY time ASC
)
TO '/Users/daiwei/dev/class-projects/inst737/twitter-collector/csv/retweet_count_at_time-536729769631842300.csv'
DELIMITER ',' CSV HEADER;
