library(Metrics) # enable mse function
library(glmnet)

data = read.csv('tweets.csv')[c(
  'created_at_day_of_week',
  'tweet_created_at_since_midnight',
  'dead_min_since_create',
  'has_hashtags',
  'has_user_mentions',
  'has_photo',
  'user_verified',
  'user_followers_count',
  'user_friends_count',
  'user_listed_count',
  'user_statuses_count',
  'user_created_at_unix')]

data$created_at_day_of_week = factor(data$created_at_day_of_week)

splitdf <- function(dataframe, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  index      = 1:nrow(dataframe)
  trainindex = sample(index, 3000)
  trainset   = dataframe[trainindex,]
  testset    = dataframe[-trainindex,]
  return(list(trainset = trainset, testset = testset))
}

splits = splitdf(data)
data.train = splits$trainset
data.test  = splits$testset

data.lm = lm(dead_min_since_create ~ ., data=data.train)

summary(data.lm)

data.pred = predict(data.lm, newdata=data.test)

cor(data.pred, data.test$dead_min_since_create)
mse(data.pred, data.test$dead_min_since_create)
