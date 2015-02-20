#read data
data = read.csv('tweets.csv')[c(
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
#sample function
splitdf <- function(dataframe, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  index      = 1:nrow(dataframe)
  trainindex = sample(index, 28000)
  trainset   = dataframe[trainindex,]
  testset    = dataframe[-trainindex,]
  return(list(trainset = trainset, testset = testset))
}
#divide data into training and testing datasets
splits = splitdf(data)
data.train = splits$trainset
data.test  = splits$testset

#apply different svm function
library(kernlab)
CLbsvr_classifier <- ksvm(dead_time ~ ., data = data.train, type = "eps-bsvr", kernel = "vanilladot")
CLbsvr_prediction <- predict(CLbsvr_classifier, data.test)
cor(CLbsvr_prediction, data.test$dead_time)

CLnu_classifier <- ksvm(dead_time ~ ., data = data.train, type = "nu-svr", kernel = "vanilladot")
CLnu_prediction <- predict(CLnu_classifier, data.test)
cor(CLnu_prediction, data.test$dead_time)

CPbsvr_classifier <- ksvm(dead_time ~ ., data = data.train, type = "eps-bsvr", kernel = "polydot")
CPbsvr_prediction <- predict(CPbsvr_classifier, data.test)
cor(CPbsvr_prediction, data.test$dead_time)

CPnu_classifier <- ksvm(dead_time ~ ., data = data.train, type = "nu-svr", kernel = "polydot")
CPnu_prediction <- predict(CPnu_classifier, data.test)
cor(CPnu_prediction, data.test$dead_time)

CRbsvr_classifier <- ksvm(dead_time ~ ., data = data.train, type = "eps-bsvr", kernel = "rbfdot")
CRbsvr_prediction <- predict(CRbsvr_classifier, data.test)
cor(CRbsvr_prediction, data.test$dead_time)

CRnu_classifier <- ksvm(dead_time ~ ., data = data.train, type = "nu-svr", kernel = "rbfdot")
CRnu_prediction <- predict(CRnu_classifier, data.test)
cor(CRnu_prediction, data.test$dead_time)

