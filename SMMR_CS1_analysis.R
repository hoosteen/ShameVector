# create a new object "bad" that will hold missing data 

bad <- is.na(BB)

# return all missing elements

BB[bad]

## ///////CLEANING DATA WITH REGEX/////// ##

# gsub substitutes punctuation with a space

BB$text <- gsub('[[:punct:]]', ' ', BB$text)

# gsub substitues character classes that do not
# give an output, such as feed, bckspce & tab w/space

BB$text <- gsub('[[:cntrl:]]', ' ', BB$text)

# gsub subs numerical values with digits >=1 w/' '

BB$text <- gsub('//d+', ' ', BB$text)

## ///////CLEANING DATA WITH SHUFFLING/////// ##

# simplify the data frame by keeping the cleaned text, 
# year and concatenated version of year/month/day

BB.text <- as.data.frame(BB$text)
BB.text$year <- BB$year
BB.text$Date <- as.Date(paste(BB$year, 
                              BB$month, 
                              BB$day, sep = "-"),
                              format = "%Y-%m-%d")
BB.text$Date <- strptime(as.character(BB.text$Date),
                         "%Y-%m-%d")

# Reassign column names

colnames(BB.text) <- c("text", "year", "date")

## ///////CLEANING DATA WITH TM_MAP/////// ##

# tm_map allows transformation to a corpus

bb_corpus <- Corpus(VectorSource(BB.text))

# stem the documents

bb.text_stm <- tm_map(bb_corpus, stemDocument)

# Standard stopwords ie the SMART list are in TM

stnd.stopwords<- stopwords("SMART")

## ////// TRANSFORMING DATA FOR SORTING ////// ## 

# useful to eliminate words that lack 
# discriminatory power. bb.tf will be used as a control 
# for the creation of our term-document matrix.

bb.tf <- list(weighting = weightTf, 
              stopwords = bb.stopwords,
              removePunctuation = TRUE,
              tolower = TRUE,
              minWordLength = 4,
              removeNumbers = TRUE)

# create a term-document matrix

bb_tdm <- TermDocumentMatrix(bb_corpus, 
                             control = bb.tf)

# sorting frequent words in TDM to ID words lacking
# discriminatory power to add to custom stopword 
# lexicon

bb.frequent <- sort(rowSums(as.matrix(bb_tdm)), 
                    decreasing = TRUE)

# further exploration

bb.frequent[1:30]

# look at terms with a minimum frequency
findFreqTerms(bb_tdm, lowfreq = 60)

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

bb.stopwords <- c(stnd.stopwords, "district",
                  "districts", "reported", "noted",
                  "city", "cited", "activity",
                  "contacts", "chicago", "dallas",
                  "kansas", "san", "richmond",
                  "francisco", "cleveland", "atlanta",
                  "sales", "boston", "york",
                  "philadelphia", "minneapolis",
                  "louis", "services", "year",
                  "levels")

## ///////WORD CLOUD/////// ##

# Remove sparse terms from the TDM w/value of 0.95,
# representing maximal allowed sparsity

BB.95 <- removeSparseTerms(bb_tdm, .95)

# Sort & count row sums of BB.95
BB.rsums <- sort(rowSums(as.matrix(BB.95)),
                 decreasing=TRUE)

# Create a data frame with words & their frequencies
BBdf.rsums <- data.frame(word=names(BB.rsums),
                         freq=BB.rsums)

# Create a blue-to-green pallete & name it w/BrewerPal

palette <- brewer.pal(9, "BuGn")
palette <- palette[-(1:2)]

# Create a PNG and definte where it will be saved
png(filename="C:/Users/Justin/Documents/GitHub/Sentiment_Monitor/Plots/BB_cloud.png")

# Create a wordcloud and define words, freq, & word size

bb.wordcloud <- wordcloud(BBdf.rsums$word, BBdf.rsums$freq,
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