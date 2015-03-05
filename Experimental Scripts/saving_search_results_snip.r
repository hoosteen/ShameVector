#Search a hashtag & save 1500 tweets to variable searchresults
searchresults <- searchTwitter("@TMobile", n=1500)

#Bind search results to a data frame
searchresults.df <- do.call(rbind,
                      lapply(searchresults, as.data.frame))

#Write searchresults data frame to a csv
write.csv(searchresults.df, "C:/Users/Justin/Documents/GitHub
          /Sentiment_Monitor")

# Load "tm" to clean csv
require("tm")

#Clean data in searchresults dataframe
searchresults_list <- sapply(searchresults, function(x) x$getText())
searchresults_corpus <- Corpus(VectorSource(searchresults_list))
searchresults_corpus <- tm_map(searchresults_corpus, tolower)
searchresults_corpus <- tm_map(searchresults_corpus, removePunctuation)
searchresults_corpus <- tm_map(searchresults_corpus, function(x) removeWords(x, stopwords()))

