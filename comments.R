# Install the necessary libraries

#Call the necessary libraries

#Download certification scheme document

#Define Twitter API keys and tokens

#Define authorization URLs

#Define oauth credentials via twitteR function  

#Save authentication settings

#Search a hashtag & save max # of tweets to variable searchresults

#Bind search results to a data frame

#Write searchresults data frame to a csv

#Clean data in searchresults dataframe

# create a new object "bad" that will hold missing data 

# return all missing elements

## ///////CLEANING DATA WITH REGEX/////// ##

# gsub substitutes punctuation with a space

# gsub substitues character classes that do not
# give an output, such as feed, bckspce & tab w/space

# gsub subs numerical values with digits >=1 w/' '


## ///////CLEANING DATA WITH SHUFFLING/////// ##

# simplify the data frame by keeping the cleaned text, 
# and other desired columns

## ///////CLEANING DATA WITH TM_MAP/////// ##

# tm_map allows transformation to a corpus

# stem the documents

# Standard stopwords ie the SMART list are in TM

## ////// TRANSFORMING DATA FOR SORTING ////// ## 

# useful to eliminate words that lack 
# discriminatory power. searchresults.tf will be used as a control 
# for the creation of our term-document matrix.

# Convert to text document for TDM conversion

# create a term-document matrix

# sorting frequent words in TDM to ID words lacking
# discriminatory power to add to custom stopword 
# lexicon

# Display 30 most frequently used terms

# look at terms with a minimum frequency

# positive words added to lexicon:

#Adding to negative words

# Corpus exploration indicates these words should
# be removed from our corpus

## ///////WORD CLOUD/////// ##

# Remove sparse terms from the TDM w/value of 0.95,
# representing maximal allowed sparsity

# Sort & count row sums of BB.95

# Create a data frame with words & their frequencies

# Create a blue-to-green pallete & name it w/BrewerPal

# Create a PNG and definte where it will be saved

# Create a wordcloud and define words, freq, & word size

# Compete plot & save the png

## ///////SENTIMENT SCORING/////// ##

# using our score.sentiment function on BB.text$text against pos.words
# and neg.words || keep date and year in variable BB.keeps since they 
# are dropped in score.sentiment output

# creating score.sentiment function

# run score.sentiment on our text field using pos.words and neg.words,
# assign to new variable BB.score

#  recombine BB.keeps with BB.score into BB.sentiment

# running colnames(BB.sentiment) verifies presence of "text", 
# "date", and "year" columns as well as the  new column "score"

# Calculate mean from raw sentiment score & assign to BB.sentiment$mean

#Calculate sum and store it in BB.sum

## /////CENTERING DATA////// ##

#Center the data by subtracting the mean from the sum

# Label observations above and below centered 
# values with 1 and code N/A with 0

##//////EXPLORING SCORES//////##

# Sum the values to get a sense of the balance of the data

# Create a histogram of raw score and centered score
# to see the impact of mean centering

# using the results from the function to score our documents we create
# a boxplot to examine the distribution of opinion relating to
# economic conditions 


# add labels to our boxplot using xlab ("Year"),
# ylab("Sentiment(Centered)"), and ggtitle ("Economic
# Sentiment - Beige Book (2011-2013)") 

# Draw boxplot

#Create wordcloud of top 100 words in search group
