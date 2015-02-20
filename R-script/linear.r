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

data.train = data[1:3000,]
data.test  = data[3001:4334,]

calc_linear <- function(data.train, data.test, y, x, degree) {
  data.reg1 = lm(as.formula(paste(y, '~', x, sep = ' ')), data = data.train)
  print(summary(data.reg1))

  rs = residuals(data.reg1)
  jpeg(paste(y, '-', x, '-residuals.jpg', sep = ''))
  qqnorm(rs)
  qqline(rs)
  dev.off()

  data.test.pred1 = predict(data.reg1, newdata = data.test)
  pc = predict(data.reg1, interval = "confidence", newdata = data.test)
  pp = predict(data.reg1, interval = "prediction", newdata = data.test)

  jpeg(paste(y, '-', x, '-scatterplot.jpg', sep=''))
  plot(data.test[x][,1], data.test[y][,1], xlab=x, ylab=y)
  matlines(data.test[x][,1], pc[,c("lwr","upr")], col='green', lty=1, type="l")
  matlines(data.test[x][,1], pp[,c("lwr","upr")], col='red', lty=1, type="l")
  dev.off()

  print(cor(data.test.pred1, data.test[y]))
  print(mse(data.test.pred1, data.test[y]))

  # Poly

  # data.train.poly = data.frame(y = data.train[y])
  # data.train.poly[,seq(2, degree + 1, 1)] = poly(data.train[x][,1], degree, raw = T)[,seq(1, degree, 1)]
  # data.reg2 = lm(as.formula(paste(y, '~ .', sep = ' ')), data = data.train.poly)
  # print(summary(data.reg2))

  # rs = residuals(data.reg2)
  # jpeg(paste(y, '-', x, '-poly-residuals.jpg', sep = ''))
  # qqnorm(rs)
  # qqline(rs)
  # dev.off()

  # data.test.poly = data.frame(y = data.test[y])
  # data.test.poly[,seq(2, degree + 1, 1)] = poly(data.test[x][,1], degree, raw = T)[,seq(1, degree, 1)]
  # data.test.pred2 = predict(data.reg2, newdata = data.test.poly)

  # pc = predict(data.reg2, interval = "confidence", newdata = data.test.poly)
  # pp = predict(data.reg2, interval = "prediction", newdata = data.test.poly)

  # jpeg(paste(y, '-', x, '-ploy-scatterplot.jpg', sep=''))
  # plot(data.test[x][,1], data.test[y][,1], xlab=x, ylab=y)
  # matlines(data.test[x][,1], pc[,c("lwr","upr")], col=3, lty=1, type="l")
  # matlines(data.test[x][,1], pp[,c("lwr","upr")], col=2, lty=1, type="l")
  # dev.off()

  # print(cor(data.test.pred2, data.test[y]))
  # print(mse(data.test.pred2, data.test[y]))
}

splitdf <- function(dataframe, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  index      = 1:nrow(dataframe)
  trainindex = sample(index, 2000)
  trainset   = dataframe[trainindex,]
  testset    = dataframe[-trainindex,]
  return(list(trainset = trainset, testset = testset))
}

calc_cor <- function(dataframe, y, x, degree) {
  result = data.frame(n = 1:100)
  for (i in 1:100) {
    splits = splitdf(dataframe)
    result$cor[i] = calc_linear(splits$trainset, splits$testset, y, x, degree)
  }
  return(mean(result$cor));
}

# calc_linear(data.train, data.test, 'dead_min_since_create', 'tweet_created_at_since_midnight', 1)
calc_linear(data.train, data.test, 'dead_min_since_create', 'user_followers_count', 1)
# calc_linear(data.train, data.test, 'dead_min_since_create', 'user_friends_count', 20)
# calc_linear(data.train, data.test, 'dead_min_since_create', 'user_listed_count', 20)
# calc_linear(data.train, data.test, 'dead_min_since_create', 'user_statuses_count', 20)
# calc_linear(data.train, data.test, 'dead_min_since_create', 'user_created_at_unix', 20)

# calc_cor(data, 'dead_min_since_create', 'tweet_created_at_since_midnight', 1)
# calc_cor(data, 'dead_min_since_create', 'tweet_created_at_since_midnight', 2)
# calc_cor(data, 'dead_min_since_create', 'tweet_created_at_since_midnight', 3)
# calc_cor(data, 'dead_min_since_create', 'tweet_created_at_since_midnight', 4)
# calc_cor(data, 'dead_min_since_create', 'tweet_created_at_since_midnight', 5)
# calc_cor(data, 'dead_min_since_create', 'tweet_created_at_since_midnight', 6)
# calc_cor(data, 'dead_min_since_create', 'tweet_created_at_since_midnight', 7)
# calc_cor(data, 'dead_min_since_create', 'tweet_created_at_since_midnight', 9)
# calc_cor(data, 'dead_min_since_create', 'tweet_created_at_since_midnight', 20)


# # # mutivariable prediction
# # LModel <- lm(dead_min_since_create~.,data=data_train)
# # LMprediction <- predict(LModel,newdata=data_test)
# # cor(LMprediction,data_test$dead_min_since_create)
# # mse(LMprediction,data_test$dead_min_since_create)
# # RLModel.fit <- cv.glmnet(as.matrix(data_train[,-(3:9)]),as.vector(data_train$dead_min_since_create),alpha=1)
# # plot(RLModel.fit)
# # coef(RLModel.fit)
# # Rprediction <- predict(RLModel.fit,newx=as.matrix(data_test[,-(3:9)]))
# # cor(Rprediction,as.vector(data_test$dead_min_since_create))
