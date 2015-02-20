#initialize and clean data
library(Metrics)
setwd("/Users/Wind/Desktop")
rawdata<-read.csv("tweets.csv")
data=rawdata[-c(1:3,5:23,26:27,29,34:41,47,49:67)]

#create train and test data
data_train=data[1:3000,]
data_test=data[3001:4334,]

#logistic regression
LogitModel<-glm(dead_min_since_create~.,data=data_train,family="binomial")
