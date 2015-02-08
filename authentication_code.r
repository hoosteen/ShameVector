#Call the necessary libraries
library(twitteR)
library(ROAuth)
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

#Call authorization handshake
twittercreds$handshake(cainfo="C:/Users/Justin/Documents/GitHub/Sentiment_Monitor/cacert.pem")
