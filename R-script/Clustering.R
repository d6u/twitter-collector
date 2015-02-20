#Read data
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
splitdf <- function(dataframe, seed = NULL, number) {
  if (!is.null(seed)) set.seed(seed)
  index      = 1:nrow(dataframe)
  trainindex = sample(index, number)
  trainset   = dataframe[trainindex,]
  testset    = dataframe[-trainindex,]
  return(list(trainset = trainset, testset = testset))
}

#sample data to form a small dataset
data.temp <- splitdf(data, number = 34000)$trainset

#K-mean Clustering
dataM <- as.matrix(model.matrix(~.+0, data = data.temp[c(-2)]))
KMcluster <- kmeans(dataM,9)
plot(dataM, col = KMcluster$cluster)
for (i in 1:9) {
  print(mean(data.temp[(KMcluster$cluster == i),]$dead_time) / (24*60))
}

#Hierarchical Clustering
data.temp <- splitdf(data, number = 200)$trainset
Hcluster <- hclust(dist(data.temp),"cen")
plot(Hcluster)

#Density based Clustering
library(fpc)
data.temp <- splitdf(data, number = 8000)$trainset
data.temp <- as.data.frame(lapply(data.temp, as.numeric))
DBcluster <- dbscan(data.temp, eps = 0.34, MinPts = 6, showplot = 1)
#plot(data.temp,col = DBcluster$cluster)
for (i in 0:8) {
  print(mean(data.temp[(DBcluster$cluster == i),]$dead_time) / (24*60))
}

#Mixture Model Clustering
library(mclust)
data.temp <- splitdf(data, number = 8000)$trainset
Mcluster <- Mclust(data.temp[c(-2)])
#plot(Mcluster)
for (i in 1:9) {
  print(mean(data.temp[(Mcluster$classification == i),]$dead_time) / (24*60))
}

