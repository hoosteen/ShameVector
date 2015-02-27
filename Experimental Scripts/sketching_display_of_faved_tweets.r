#Load Packages

library(dplyr)

#Display Data Frame
head(pandas.df)
pandas.df
#Convert to a local data frame
pandas <- tbl_df(pandas.df)

#Display in full data frame
data.frame(head(pandas))

# Display the text, fave status & number of faves for favorited tweets

filteredmobile <- tmobile %>%
  group_by(filteredmobile, isRetweet) %>%
  select(text, favorited, favoriteCount)  %>%
  filter(filteredmobile, isRetweet==TRUE)	

filteredmobile
