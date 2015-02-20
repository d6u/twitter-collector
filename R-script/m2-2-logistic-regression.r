library(caret)

data = read.csv("tweets.csv")[c(
  'created_at_day',
  'dead_time',
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

data$dead_time = factor(data$dead_time > 24 * 60)

splitdf <- function(dataframe, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  index      = 1:nrow(dataframe)
  trainindex = sample(index, 28000)
  trainset   = dataframe[trainindex,]
  testset    = dataframe[-trainindex,]
  return(list(trainset = trainset, testset = testset))
}

splits = splitdf(data)
data.train = splits$trainset
data.test  = splits$testset

data.logit = glm(dead_time ~ ., data = data.train, family = "binomial")
summary(data.logit)
print("------------------------------------")

data.predict = predict(data.logit, newdata = data.test, type = "response")

data.predict = factor(data.predict > 0.5)
confusionMatrix(data.predict, data.test$dead_time)
