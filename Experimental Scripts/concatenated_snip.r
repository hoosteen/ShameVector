# Install the necessary libraries
install.packages("twitteR")
install.packages("RCurl")
install.packages("RColorBrewer")
install.packages("tm")
install.packages("wordcloud")
install.packages("httpuv")
install.packages("dplyr")
install.packages("SnowballC")

#Call the necessary libraries
library("twitteR")
library("RCurl")
library("RColorBrewer")
library("tm")
library("wordcloud")
library("httpuv")
library("dplyr")
library("SnowballC")

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

#Search a hashtag & save max # of tweets to variable searchresults
searchresults <- searchTwitter("#WalterScott", n=2480)

#Bind search results to a data frame
searchresults.df <- do.call(rbind,
                            lapply(searchresults, as.data.frame))

#Write searchresults data frame to a csv
write.csv(searchresults.df, "~/GitHub/ShameVector/TestData/WalterScott.csv")

#Clean data in searchresults dataframe
searchresults_list <- sapply(searchresults, function(x) x$getText())

# create a new object "bad" that will hold missing data 

NAs <- is.na(searchresults)

# return all missing elements

searchresults[NAs]

## ///////CLEANING DATA WITH REGEX/////// ##

# gsub substitutes punctuation with a space

searchresults$text <- gsub('[[:punct:]]', ' ', searchresults$text)

# gsub substitues character classes that do not
# give an output, such as feed, bckspce & tab w/space

searchresults$text <- gsub('[[:cntrl:]]', ' ', searchresults$text)

# gsub subs numerical values with digits >=1 w/' '

searchresults$text <- gsub('//d+', ' ', searchresults$text)

## ///////CLEANING DATA WITH SHUFFLING/////// ##

# simplify the data frame by keeping the cleaned text, 
# and other desired columns

searchresults.text <- as.data.frame(searchresults$text)
searchresults.sn <- searchresults$screenName

## ///////CLEANING DATA WITH TM_MAP/////// ##

# tm_map allows transformation to a corpus

searchresults_corpus <- Corpus(VectorSource(searchresults.text))
searchresults_corpus <- tm_map(searchresults_corpus, tolower)
searchresults_corpus <- tm_map(searchresults_corpus, removePunctuation)
searchresults_corpus <- tm_map(searchresults_corpus, function(x) removeWords(x, stopwords()))

# stem the documents

searchresults.text_stm <- tm_map(searchresults_corpus, stemDocument)

# Standard stopwords ie the SMART list are in TM

stnd.stopwords<- stopwords("SMART")

## ////// TRANSFORMING DATA FOR SORTING ////// ## 

# useful to eliminate words that lack 
# discriminatory power. searchresults.tf will be used as a control 
# for the creation of our term-document matrix.

searchresults.tf <- list(weighting = weightTf, 
               stopwords = stnd.stopwords,
               removePunctuation = TRUE,
               tolower = TRUE,
               minWordLength = 4,
               removeNumbers = TRUE)

# Convert to text document

searchresults_corpus_text <- tm_map(searchresults_corpus, PlainTextDocument)

# create a term-document matrix

searchresults_tdm <- TermDocumentMatrix(searchresults_corpus_text, 
                             control = searchresults.tf)

# sorting frequent words in TDM to ID words lacking
# discriminatory power to add to custom stopword 
# lexicon

sr.frequent <- sort(rowSums(as.matrix(searchresults_tdm)), 
                    decreasing = TRUE)

# further exploration

sr.frequent[1:30]

# look at terms with a minimum frequency
findFreqTerms(searchresults_tdm, lowfreq = 60)

# positive words added to lexicon:

pos.words<- c(pos_all, "spend", "buy", "earn", "hike", "increase",
              "increases", "development", "expansion", "raise", "surge", "add",
              "added", "advanced", "advances", "boom", "boosted", "boosting",
              "waxed", "upbeat", "surge")

#Adding to negative words

neg.words = c(neg_all, "earn", "shortfall", "weak", "fell",
              "decreases", "decreases", "decreased", "contraction", "cutback",
              "cuts", "drop", "shrinkage", "reduction", "abated", "cautious",
              "caution", "damped", "waned", "undermine", "unfavorable", "soft",
              "softening", "soften", "softer", "sluggish", "slowed", "slowdown",
              "slower", "recession")

# Corpus exploration indicates these words should
# be removed from our corpus

addl.stopwords <- c(stnd.stopwords, "WORDSTOREMOVE")

## ///////WORD CLOUD/////// ##

# Remove sparse terms from the TDM w/value of 0.95,
# representing maximal allowed sparsity

searchresults_corpus.95 <- removeSparseTerms(searchresults_tdm, .95)

# Sort & count row sums of BB.95
searchresults.rsums <- sort(rowSums(as.matrix(searchresults_corpus.95)),
                  decreasing=TRUE)

# Create a data frame with words & their frequencies
searchresults.rsums <- data.frame(word=names(searchresults.rsums),
                          freq=searchresults.rsums)

# Create a blue-to-green pallete & name it w/BrewerPal

palette <- brewer.pal(9, "BuGn")
palette <- palette[-(1:2)]

# Create a PNG and definte where it will be saved
png(filename="~/cloud.png")

# Create a wordcloud and define words, freq, & word size

searchresults.wordcloud <- wordcloud(searchresults.rsums$word, searchresults.rsums$freq,
                           random.order=FALSE, colors=palette)

# Compete plot & save the png

dev.off()

## ///////SENTIMENT SCORING/////// ##

# using our score.sentiment function on BB.text$text against pos.words
# and neg.words || keep date and year in variable BB.keeps since they 
# are dropped in score.sentiment output

BB.keeps <- BB.text[,c("date", "year")]

# creating score.sentiment function

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr)
  require(stringr)
  
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    
    word.list = str_split(sentence, '\\s+')
    words = unlist(word.list)
    
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, pos.words, neg.words, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}

# run score.sentiment on our text field using pos.words and neg.words,
# assign to new variable BB.score

BB.score <- score.sentiment(BB.text$text, pos, neg,
                            .progress = 'text')

#  recombine BB.keeps with BB.score into BB.sentiment

BB.sentiment <- cbind(BB.keeps, BB.score)

# running colnames(BB.sentiment) verifies presence of "text", 
# "date", and "year" columns as well as the  new column "score"

colnames(BB.sentiment)

# Calculate mean from raw sentiment score & assign to BB.sentiment$mean

BB.sentiment$mean <- mean(BB.sentiment$score)

#Calculate sum and store it in BB.sum

BB.sum <- BB.sentiment$score

## /////CENTERING DATA////// ##

#Center the data by subtracting the mean from the sum

BB.sentiment$centered <- BB.sum - BB.sentiment$mean

# Label observations above and below centered 
# values with 1 and code N/A with 0

BB.sentiment$pos[BB.sentiment$centered>0] <- 1
BB.sentiment$neg[BB.sentiment$centered<0] <- 1
BB.sentiment$pos[is.na(BB.sentiment$pos)] <- 0
BB.sentiment$neg[is.na(BB.sentiment$neg)] <- 0

##//////EXPLORING SCORES//////##

# Sum the values to get a sense of the balance of the data

sum(BB.sentiment$pos)
sum(BB.sentiment$neg)

# Create a histogram of raw score and centered score
# to see the impact of mean centering

BB.hist <- hist(BB.sentiment$score, main="Raw Sentiment Score",
                xlab="Score", ylab="Frequency")

BB.hist <- hist(BB.sentiment$centered, main="Sentiment Score Centered",
                xlab="Score", ylab="Frequency")

# using the results from the function to score our documents we create
# a boxplot to examine the distribution of opinion relating to
# economic conditions 

BB.boxplot <- ggplot(BB.sentiment, aes(x = BB.sentiment$year, y = BB.sentiment$centered, group = BB.text$year))
geom_boxplot(aes(fill = BB.sentiment$year), outlier.colour = "black", outlier.shape = 16, outlier.size = 2)

# add labels to our boxplot using xlab ("Year"),
# ylab("Sentiment(Centered)"), and ggtitle ("Economic
# Sentiment - Beige Book (2011-2013)")

BB.boxplot<- BB.boxplot + xlab("Year") + ylab("Sentiment (Centered)") + ggtitle("Economic Sentiment - BeigeBook Summ.") 

# Draw boxplot

BB.boxplot

# TODO: DEBUG BOXPLOT

#Create wordcloud of top 100 words in search group
wordcloud(searchresults_corpus, scale=c(5,0.5), max.words=100, 
          random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
