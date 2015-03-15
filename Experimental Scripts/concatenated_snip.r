# Install the necessary libraries
install.packages("twitteR")
install.packages("RCurl")
install.packages("RColorBrewer")
install.packages("tm")
install.packages("wordcloud")
install.packages("httpuv")
install.packages("tm")
install.packages("dplyr")

#Call the necessary libraries
library("twitteR")
library("RCurl")
library("RColorBrewer")
library("tm")
library("wordcloud")
library("httpuv")
library("tm")
library("dplyr")

#Download certification scheme document
download.file(url="http://curl.haxx.se/ca/cacert.pem",
              destfile="C:/Users/Justin/Documents/GitHub/ShameVector/Utilities/cacert.pem")

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

#Search a hashtag & save 1500 tweets to variable searchresults
searchresults <- searchTwitter("TPP", n=5000)

#Bind search results to a data frame
searchresults.df <- do.call(rbind,
                            lapply(searchresults, as.data.frame))

#Write searchresults data frame to a csv
write.csv(searchresults.df, "C:/Users/Justin/Documents/GitHub/ShameVector/Case Studies/TestData/TPPsearchresults1.csv")

# Load "tm" to clean csv
require("tm")

#Clean data in searchresults dataframe
searchresults_list <- sapply(searchresults, function(x) x$getText())
searchresults_corpus <- Corpus(VectorSource(searchresults_list))
# Debug line: searchresults_corpus <- tm_map(searchresults_corpus, tolower)
searchresults_corpus <- tm_map(searchresults_corpus, removePunctuation)
searchresults_corpus <- tm_map(searchresults_corpus, function(x) removeWords(x, stopwords()))

#Create wordcloud of top 100 words in search group
wordcloud(searchresults_corpus, scale=c(5,0.5), max.words=100, 
          random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
