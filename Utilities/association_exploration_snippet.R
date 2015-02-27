#Load text mining library
library(tm)

# Creates document term matrix & assigns to usearch.tdm 
usearch.tdm <- TermDocumentMatrix(usearch_corpus)

# Identify terms use at least 100 times
findFreqTerms(usearch.tdm, lowfreq=100)

#Explore association of terms
findAssocs(usearch.tdm, 'corporate', 0.50)

# Remove sparse terms from the TDM
usearch2.tdm <- removeSparseTerms(usearch.tdm, sparse=0.92)

#Convert the TDM to a data frame
usearch2.df <- as.data.frame(usearch2.tdm)
