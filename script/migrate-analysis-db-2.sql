ALTER TABLE original_tweets
  ADD COLUMN geo_lon double precision,
  ADD COLUMN geo_lat double precision,
  ADD COLUMN has_hashtags boolean,
  ADD COLUMN has_trends boolean,
  ADD COLUMN has_urls boolean,
  ADD COLUMN has_user_mentions boolean,
  ADD COLUMN has_symbols boolean,
  ADD COLUMN has_photo boolean;
