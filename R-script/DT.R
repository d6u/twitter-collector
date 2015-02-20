#initialize and clean data
library(Metrics)
library(gmodels)
setwd("/Users/Wind/Desktop")
rawdata <- read.csv("tweets_with_cat.csv")
#data=rawdata[-c(1:3,5:23,26:27,29,34:41,47,49:67)]
data = rawdata[-c(1, 4, 11:13)]
data$dead_min_since_create <- factor(as.integer(data$dead_min_since_create/(60 * 12)))
data$tweet_created_at_since_midnight <- as.integer(data$tweet_created_at_since_midnight/180)
data$tweet_created_at_since_midnight <- factor(data$tweet_created_at_since_midnight)
data$user_created_at_unix <- as.integer(data$user_created_at_unix/180/24/365/3)
data$user_created_at_unix <- factor(data$user_created_at_unix)
data$created_at_day_of_week <- factor(data$created_at_day_of_week)
data$user_followers_count <- factor(as.integer(data$user_followers_count/1000000))
data$user_friends_count <- factor(as.integer(data$user_friends_count/1000))
data$user_listed_count <- factor(as.integer(data$user_listed_count/50000))
data$user_statuses_count <- factor(as.integer(data$user_statuses_count/10000))
str(data)
#create train and test data
splitdf <- function(dataframe, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  index      = 1:nrow(dataframe)
  trainindex = sample(index, 3000)
  trainset   = dataframe[trainindex,]
  testset    = dataframe[-trainindex,]
  return(list(trainset = trainset, testset = testset))
}
splits = splitdf(data)
data_train = splits$trainset
data_test = splits$testset



#decision tree
library(C50)
DTModel <- C5.0(data_train[,-3,],data_train[,3])
DTPredict <- predict(DTModel,data_test)
summary(DTModel)
CrossTable(data_test$dead_min_since_create,DTPredict,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual time','predicted time'))

#boosting

BModel10 <- C5.0(data_train[,-3], data_train[,3], trials = 6)
BPredict <- predict(BModel10,data_test)
summary(BModel10)
CrossTable(data_test$dead_min_since_create,BPredict,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual time','predicted time'))

#Bagging & Random Forests
library(ISLR)
library(MASS)
library(randomForest)
set.seed(1)
data_train_BR <- sample(1:nrow(data),replace = TRUE)

bag.Model <- randomForest(formula=dead_min_since_create~.,subset = data_train_BR, data=data,mtry=14)
bag.Predict <- predict(bag.Model, newdata = data[,-3])
mean((BPredict-data[-data_train_BR,3])^2)
CrossTable(data$dead_min_since_create,bag.Predict,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual time','predicted time'))

RF.Model <- randomForest(formula=dead_min_since_create~.,subset = data_train_BR, data=data,mtry=7)
RF.Predict <- predict(RF.Model, newdata = data[,-3])
CrossTable(data$dead_min_since_create,RF.Predict,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual time','predicted time'))

RF.Model <- randomForest(formula=dead_min_since_create~.,subset = data_train_BR, data=data,mtry=8)
RF.Predict <- predict(RF.Model, newdata = data[,-3])
CrossTable(data$dead_min_since_create,RF.Predict,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual time','predicted time'))

RF.Model <- randomForest(formula=dead_min_since_create~.,subset = data_train_BR, data=data,mtry=9)
RF.Predict <- predict(RF.Model, newdata = data[,-3])
CrossTable(data$dead_min_since_create,RF.Predict,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual time','predicted time'))

RF.Model <- randomForest(formula=dead_min_since_create~.,subset = data_train_BR, data=data,mtry=10)
RF.Predict <- predict(RF.Model, newdata = data[,-3])
CrossTable(data$dead_min_since_create,RF.Predict,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual time','predicted time'))

RF.Model <- randomForest(formula=dead_min_since_create~.,subset = data_train_BR, data=data,mtry=11)
RF.Predict <- predict(RF.Model, newdata = data[,-3])
CrossTable(data$dead_min_since_create,RF.Predict,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual time','predicted time'))

RF.Model <- randomForest(formula=dead_min_since_create~.,subset = data_train_BR, data=data,mtry=12)
RF.Predict <- predict(RF.Model, newdata = data[,-3])
CrossTable(data$dead_min_since_create,RF.Predict,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual time','predicted time'))

RF.Model <- randomForest(formula=dead_min_since_create~.,subset = data_train_BR, data=data,mtry=13)
RF.Predict <- predict(RF.Model, newdata = data[,-3])
CrossTable(data$dead_min_since_create,RF.Predict,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual time','predicted time'))
