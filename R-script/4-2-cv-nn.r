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

data <- as.data.frame(lapply(data, as.numeric))

inTraining <- createDataPartition(data$dead_time, p = 1, list = FALSE)

training = data[inTraining,]

fitControl <- trainControl(method = "cv", number = 3)

nnFit1 <- train(x = training[,2:43], y = training$dead_time, method = "neuralnet", trControl = fitControl)

nnFit1
