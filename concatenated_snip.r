#Call the necessary libraries
library(twitteR)
library(RCurl)

#Download certification scheme document
download.file(url="http://curl.haxx.se/ca/cacert.pem",
              destfile="C:/Users/Justin/Documents/GitHub/Sentiment_Monitor/cacert.pem")

#Define Twitter API keys and tokens
consumerKey <- "K2mpLnVJuDXlSqvC8KzaWgP5P"
consumerSecret <- "uzBix30ghVTFEciPOg3kuJLnZ4Kp2CaSJGl0FnIFNFOPBhkCn0"
access_token <- "14313727-hBhnH9BGe6hqV6nrhUyrUZ5hUi4IQmRW8zYVJgP0C"
access_token_secret <- "ZrOdr8Dv3k4wwEaOEs52hRkYTaFRoodvyfPXxfw6i8Aqa"

#Define authorization URLs
requestURL='https://api.twitter.com/oauth/request_token'
accessURL='https://api.twitter.com/oauth/access_token'
authURL='https://api.twitter.com/oauth/authorize'

#Define oauth credentials via twitteR function  
twittercreds <- setup_twitter_oauth(consumerKey, consumerSecret)

#Save authentication settings
save(twittercreds, file="twitter authentication data.Rdata")

#Search #1U hashtag & save 1500 tweets to variable usearch
usearch <- searchTwitter("#1u", n=1500)

#Bind #1U search results to a data frame
usearch.df <- do.call(rbind,
                      lapply(usearch, as.data.frame))

#Write #1U data frame to a csv
write.csv(usearch.df, "C:/Users/Justin/Desktop/usearch2.csv")

#Install & Load "tm" to clean csv
install.packages("tm", dependencies=TRUE)
library("tm")

#Clean data in usearch dataframe
usearch_list <- sapply(usearch, function(x) x$getText())
usearch_corpus <- Corpus(VectorSource(usearch_list))
usearch_corpus <- tm_map(usearch_corpus, tolower)
usearch_corpus <- tm_map(usearch_corpus, removePunctuation)
usearch_corpus <- tm_map(usearch_corpus, function(x) removeWords(x, stopwords()))
usearch_corpus <- tm_map(usearch_corpus, PlainTextDocument)

#Install & Load WordCloud Package
install.packages("wordcloud", dependencies=TRUE)
library("wordcloud")

#Create wordcloud of #1U hashtag
wordcloud(usearch_corpus)
