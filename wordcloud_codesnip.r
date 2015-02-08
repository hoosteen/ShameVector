#Install & Load WordCloud Package
install.packages("wordcloud", dependencies=TRUE)
library("wordcloud")

#Create wordcloud of top 100 words in #1U hashtag
wordcloud(..., scale=c(5,0.5), max.words=100, 
          random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
