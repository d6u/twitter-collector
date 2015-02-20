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

data <- as.data.frame(lapply(data, as.numeric))

library(neuralnet)
normalize <- function(x){
  return((x-min(x)) / (max(x)-min(x)))
}
splitdf <- function(dataframe, seed = NULL, number) {
  if (!is.null(seed)) set.seed(seed)
  index      = 1:nrow(dataframe)
  trainindex = sample(index, number)
  trainset   = dataframe[trainindex,]
  testset    = dataframe[-trainindex,]
  return(list(trainset = trainset, testset = testset))
}

data.temp <- splitdf(data, number = 8000)$trainset
data_norm <- as.data.frame(lapply(data.temp, normalize))

splits = splitdf(data_norm, number = 6000)
data.train = splits$trainset
data.test  = splits$testset


test <- function(x) {
  model_1 <- neuralnet(formula = dead_time ~ created_at_day
                     + dead_time_total_retweet
                     + has_hashtags
                     + has_urls
                     + has_symbols
                     + has_user_mentions
                     + has_photo
                     + user_verified
                     + user_ss_follower_count
                     + user_ss_friends_count
                     + user_ss_listed_count
                     + user_ss_statuses_count
                     + cat_technology
                     + cat_business
                     + cat_staff_picks
                     + cat_gaming
                     + cat_entertainment
                     + cat_food_drink
                     + cat_art_design
                     + cat_news
                     + cat_health 
                     + cat_science 
                     + cat_nba 
                     + cat_funny 
                     + cat_photography 
                     + cat_twitter 
                     + cat_government 
                     + cat_sports 
                     + cat_books 
                     + cat_travel 
                     + cat_music 
                     + cat_social_good 
                     + cat_faith_and_religion 
                     + cat_family 
                     + cat_television 
                     + cat_nascar 
                     + cat_fashion 
                     + cat_pga 
                     + cat_nhl 
                     + cat_mlb 
                     + user_created_at_unix 
                     + user_has_url, data = data.train, hidden = x)
  results_1 <- compute(model_1, data.test[-2])
  jpeg('aaa.jpg')
  plot(model_1)
  dev.off()
  print(cor(results_1$net.result, data.test$dead_time))
}

test(1)
test(3)
test(5)
test(c(2,2))
test(c(3,3))
test(c(2,2,2))
test(c(4,4,4))
test(c(3,2,3))
test(c(2,4,2,3))
test(c(5,5,5,5))