usearch.tdm <- TermDocumentMatrix(usearch_corpus)
usearch.tdm

# Identify terms use at least 10 times
findFreqTerms(usearch.tdm, lowfreq=100)

#Explore association of terms
findAssocs(usearch.tdm, 'scott', 0.50)

# Remove sparse terms from the TDM
usearch2.tdm <- removeSparseTerms(usearch.tdm, sparse=0.92)

#Convert the TDM to a data frame
usearch2.df <- as.data.frame(usearch2.tdm)
