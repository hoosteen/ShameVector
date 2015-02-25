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
BB$text <- gsub('\\d+', ' ', BB$text)

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

## ///////SENTIMENT SCORING/////// ##

# using our score.sentiment function on BB.text$text against pos.words
# and neg.words || keep date and year in variable BB.keeps since they 
# are dropped in score.sentiment output

BB.keeps <- BB.text[,c("date", "year")]

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

#Center the data by subtracting the sum from the mean
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