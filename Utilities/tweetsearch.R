#Install & Call the necessary packages

install.packages("twitteR")
install.packages("RCurl")
install.packages("RColorBrewer")
install.packages("tm")
install.packages("wordcloud")
library(twitteR)
library(RCurl)
library(RColorBrewer)
library(tm)
library(wordcloud)

#Add your keys

consumerKey <- "K2mpLnVJuDXlSqvC8KzaWgP5P"
consumerSecret <- "uzBix30ghVTFEciPOg3kuJLnZ4Kp2CaSJGl0FnIFNFOPBhkCn0"
access_token <- "14313727-hBhnH9BGe6hqV6nrhUyrUZ5hUi4IQmRW8zYVJgP0C"
access_token_secret <- "ZrOdr8Dv3k4wwEaOEs52hRkYTaFRoodvyfPXxfw6i8Aqa"

#Define oauth credentials via twitteR function  
twittercreds <- setup_twitter_oauth(consumerKey, consumerSecret)

#Save authentication settings
save(twittercreds, file="twitter authentication data.Rdata")

#Input a SEARCH TERM or hashtag & save 1500 tweets to variable
SEARCH_TERM <- searchTwitter(

#Search term & number of tweets
  "SEARCH_TERM", n=2480)

#Bind SEARCH TERM search results to a data frame
SEARCH_TERM.df <- do.call(rbind,
                      lapply(SEARCH_TERM, as.data.frame))

#Export data frame to csv
write.csv(SEARCH_TERM.df, file="FILENAME.csv")

#convert all text to lower case
SEARCH_TERM.df <- tolower(SEARCH_TERM.df)

# Replace blank space ("rt")
SEARCH_TERM.df <- gsub("rt", "", SEARCH_TERM.df)

# Replace @UserName
SEARCH_TERM.df <- gsub("@\\w+", "", SEARCH_TERM.df)

# Remove punctuation
SEARCH_TERM.df <- gsub("[[:punct:]]", "", SEARCH_TERM.df)

# Remove links
SEARCH_TERM.df <- gsub("http\\w+", "", SEARCH_TERM.df)

# Remove tabs
SEARCH_TERM.df <- gsub("[ |\t]{2,}", "", SEARCH_TERM.df)

# Remove blank spaces at the beginning
SEARCH_TERM.df <- gsub("^ ", "", SEARCH_TERM.df)

# Remove blank spaces at the end
SEARCH_TERM.df <- gsub(" $", "", SEARCH_TERM.df)

# Create corpus from data frame to use text mining library
SEARCH_TERM_corpus <- Corpus(VectorSource(SEARCH_TERM.df))

# Remove stopwords from corpus
SEARCH_TERM_corpus <- tm_map(SEARCH_TERM_corpus, 
                             function(x) removeWords(x, stopwords()))


#Create wordcloud of top 100 words in #1U hashtag
wordcloud(wydensearch_corpus, scale=c(5,0.5), max.words=100, 
          random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))

#Load text mining library
library(tm)

# Creates document term matrix & assigns to SEARCH_TERM.tdm 
SEARCH_TERM.tdm <- TermDocumentMatrix(SEARCH_TERM_corpus)

# Identify terms use at least 100 times
findFreqTerms(SEARCH_TERM.tdm, lowfreq=50)

#Explore association of terms
findAssocs(SEARCH_TERM.tdm, 'beyonce', 0.50)

# Remove sparse terms from the TDM
SEARCH_TERM2.tdm <- removeSparseTerms(SEARCH_TERM.tdm, sparse=0.92)

#Convert the TDM to a data frame
SEARCH_TERM2.df <- as.data.frame(SEARCH_TERM2.tdm)