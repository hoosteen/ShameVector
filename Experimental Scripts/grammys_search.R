#Call the necessary libraries
library(twitteR)
library(RCurl)
library(RColorBrewer)
library(tm)
library(wordcloud)

#Define oauth credentials via twitteR function  
twittercreds <- setup_twitter_oauth(consumerKey, consumerSecret)

#Save authentication settings
save(twittercreds, file="twitter authentication data.Rdata")

#Search #AdviceForYoungJournalists hashtag & save 1500 tweets to variable YoungJourno
YoungJourno <- searchTwitter("#AdviceForYoungJournalists", n=1000)

#Bind #AdviceForYoungJournalists search results to a data frame
YoungJourno.df <- do.call(rbind,
                      lapply(YoungJourno, as.data.frame))

#Export data frame to csv
write.csv(YoungJourno.df, file="YoungJourno.csv")

#convert all text to lower case
YoungJourno.df <- tolower(YoungJourno.df)

# Replace blank space ("rt")
YoungJourno.df <- gsub("rt", "", YoungJourno.df)

# Replace @UserName
YoungJourno.df <- gsub("@\\w+", "", YoungJourno.df)

# Remove punctuation
YoungJourno.df <- gsub("[[:punct:]]", "", YoungJourno.df)

# Remove links
YoungJourno.df <- gsub("http\\w+", "", YoungJourno.df)

# Remove tabs
YoungJourno.df <- gsub("[ |\t]{2,}", "", YoungJourno.df)

# Remove blank spaces at the beginning
YoungJourno.df <- gsub("^ ", "", YoungJourno.df)

# Remove blank spaces at the end
YoungJourno.df <- gsub(" $", "", YoungJourno.df)

# Create corpus from data frame to use text mining library
YoungJourno_corpus <- Corpus(VectorSource(YoungJourno.df))

# Remove stopwords from corpus
YoungJourno_corpus <- tm_map(YoungJourno_corpus, function(x) removeWords(x, stopwords()))


#Create wordcloud of top 100 words in #1U hashtag
wordcloud(YoungJourno_corpus, scale=c(5,0.5), max.words=100, 
          random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))

#Load text mining library
library(tm)

# Creates document term matrix & assigns to YoungJourno.tdm 
YoungJourno.tdm <- TermDocumentMatrix(YoungJourno_corpus)

# Identify terms use at least 100 times
findFreqTerms(YoungJourno.tdm, lowfreq=50)

#Explore association of terms
findAssocs(YoungJourno.tdm, 'beyonce', 0.50)

# Remove sparse terms from the TDM
YoungJourno2.tdm <- removeSparseTerms(YoungJourno.tdm, sparse=0.92)

#Convert the TDM to a data frame
YoungJourno2.df <- as.data.frame(YoungJourno2.tdm)