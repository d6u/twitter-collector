library(caret)

data <- read.csv("tweets.csv")[c(
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

data$dead_time <- factor(data$dead_time > 24 * 60)

# partition
inTraining <- createDataPartition(data$dead_time, p = 0.75, list = FALSE)
training   <- data[inTraining,]
testing    <- data[-inTraining,]

# 10-fold CV
fitControl <- trainControl(method = "repeatedcv", number = 10)

glmFit1 <- train(dead_time ~ .,
  data = training,
  method = "glm",
  trControl = fitControl,
  family = "binomial")

print(glmFit1)
print("-------------------------------")

# Data Split
#
runtest <- function(trainP) {
  # partition
  inTraining <- createDataPartition(data$dead_time, p = trainP, list = FALSE)
  training   <- data[inTraining,]
  testing    <- data[-inTraining,]

  data.logit <- glm(dead_time ~ ., data = training, family = "binomial")

  data.predict <- predict(data.logit, newdata = testing, type = "response")
  data.predict <- factor(data.predict > 0.5)

  confusionMatrix(data.predict, testing$dead_time)
}

runtest(0.9)
print("-------------------------------")
runtest(0.8)
print("-------------------------------")
runtest(0.7)
print("-------------------------------")
runtest(0.6)
print("-------------------------------")
runtest(0.5)
print("-------------------------------")
runtest(0.4)
