rawdata <- read.csv("tweets_with_cat.csv")

#data=rawdata[-c(1:3,5:23,26:27,29,34:41,47,49:67)]
#
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

jpeg('-data_dead_min.jpg')
hist(as.integer(data$dead_min_since_create))
dev.off()

jpeg(paste('-train_dead_min.jpg', sep = ''))
hist(as.integer(data_train$dead_min_since_create))
dev.off()

jpeg(paste('-test_dead_min.jpg', sep = ''))
hist(as.integer(data_test$dead_min_since_create))
dev.off()

jpeg(paste('-data_usercat.jpg', sep = ''))
hist(as.integer(data$user_category))
dev.off()

jpeg(paste('-train_usercat.jpg', sep = ''))
hist(as.integer(data_train$user_category))
dev.off()

jpeg(paste('-test_usercat.jpg', sep = ''))
hist(as.integer(data_test$user_category))
dev.off()
