#Call the necessary libraries
library(twitteR)
library(RCurl)
library(RColorBrewer)
library(tm)
library(wordcloud)
library(gdata)

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

#Search #1U hashtag & save 1500 tweets to variable GrammySearch
GrammySearch <- searchTwitter("#Grammys", n=2000)

#Bind #1U search results to a data frame
GrammySearch.df <- do.call(rbind,
                      lapply(GrammySearch, as.data.frame))

#convert all text to lower case
GrammySearch.df <- tolower(GrammySearch.df)

# Replace blank space ("rt")
GrammySearch.df <- gsub("rt", "", GrammySearch.df)

# Replace @UserName
GrammySearch.df <- gsub("@\\w+", "", GrammySearch.df)

# Remove punctuation
GrammySearch.df <- gsub("[[:punct:]]", "", GrammySearch.df)

# Remove links
GrammySearch.df <- gsub("http\\w+", "", GrammySearch.df)

# Remove tabs
GrammySearch.df <- gsub("[ |\t]{2,}", "", GrammySearch.df)

# Remove blank spaces at the beginning
GrammySearch.df <- gsub("^ ", "", GrammySearch.df)

# Remove blank spaces at the end
GrammySearch.df <- gsub(" $", "", GrammySearch.df)

# Create corpus from data frame to use text mining library
GrammySearch_corpus <- Corpus(VectorSource(GrammySearch.df))

# Remove stopwords from corpus
GrammySearch_corpus <- tm_map(GrammySearch_corpus, function(x) removeWords(x, stopwords()))

#Remove "Grammys" from corpus
removeWords(GrammySearch_corpus)

#Create wordcloud of top 100 words in #1U hashtag
wordcloud(GrammySearch_corpus, scale=c(5,0.5), max.words=100, 
          random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))

#Load text mining library
library(tm)

# Creates document term matrix & assigns to GrammySearch.tdm 
GrammySearch.tdm <- TermDocumentMatrix(GrammySearch_corpus)

# Identify terms use at least 100 times
findFreqTerms(GrammySearch.tdm, lowfreq=50)

#Explore association of terms
findAssocs(GrammySearch.tdm, 'beyonce', 0.50)

# Remove sparse terms from the TDM
GrammySearch2.tdm <- removeSparseTerms(GrammySearch.tdm, sparse=0.92)

#Convert the TDM to a data frame
GrammySearch2.df <- as.data.frame(GrammySearch2.tdm)