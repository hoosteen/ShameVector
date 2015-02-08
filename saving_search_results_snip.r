#Search #1U hashtag & save 1500 tweets to variable usearch
usearch <- searchTwitter("#1u", n=1500)

#Bind #1U search results to a data frame
usearch.df <- do.call(rbind,
                      lapply(usearch, as.data.frame))

#Write #1U data frame to a csv
write.csv(usearch.df, "C:/Users/Justin/Documents/GitHub
          /Sentiment_Monitor")

#Install & Load "tm" to clean csv
install.packages("tm", dependencies=TRUE)
library("tm")

#Clean data in usearch dataframe
usearch_list <- sapply(usearch, function(x) x$getText())
usearch_corpus <- Corpus(VectorSource(usearch_list))
usearch_corpus <- tm_map(usearch_corpus, tolower)
usearch_corpus <- tm_map(usearch_corpus, removePunctuation)
usearch_corpus <- tm_map(usearch_corpus, function(x) removeWords(x, stopwords()))
