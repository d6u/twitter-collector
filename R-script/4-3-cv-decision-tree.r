library(caret)

data <- read.csv("tweets.csv")[c(
  'dead_time',
  'created_at_day',
  'dead_time_total_retweet',
  'has_hashtags',
  'has_urls',
  'has_symbols',
  'has_user_mentions',
  'has_photo',
  'user_verified',
  'user_ss_follower_count',
  'user_ss_friends_count',
  'user_ss_listed_count',
  'user_ss_statuses_count',
  'cat_technology',
  'cat_business',
  'cat_staff_picks',
  'cat_gaming',
  'cat_entertainment',
  'cat_food_drink',
  'cat_art_design',
  'cat_news',
  'cat_health',
  'cat_science',
  'cat_nba',
  'cat_funny',
  'cat_photography',
  'cat_twitter',
  'cat_government',
  'cat_sports',
  'cat_books',
  'cat_travel',
  'cat_music',
  'cat_social_good',
  'cat_faith_and_religion',
  'cat_family',
  'cat_television',
  'cat_nascar',
  'cat_fashion',
  'cat_pga',
  'cat_nhl',
  'cat_mlb',
  'user_created_at_unix',
  'user_has_url')]

data$dead_time <- factor(data$dead_time > 24 * 60)

data$created_at_day         <- factor(data$created_at_day)
data$user_ss_follower_count <- factor(as.integer(data$user_ss_follower_count / 1000000))
data$user_ss_friends_count  <- factor(as.integer(data$user_ss_friends_count / 1000))
data$user_ss_listed_count   <- factor(as.integer(data$user_ss_listed_count / 50000))
data$user_ss_statuses_count <- factor(as.integer(data$user_ss_statuses_count / 10000))
data$user_created_at_unix   <- factor(as.integer(data$user_created_at_unix / 180 / 24 / 365 / 3))

# 10-fold CV
fitControl <- trainControl(method = "cv", number = 3)

dtFit1 <- train(x = data[,2:43], y = data$dead_time, method = "C5.0", trControl = fitControl)

dtFit1
