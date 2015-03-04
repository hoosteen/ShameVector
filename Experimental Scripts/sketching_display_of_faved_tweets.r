##TO-DO
## - 
##  - 

#Load Packages

library(dplyr)

#Display Data Frame
head(dataframe.df)
dataframe.df

#Convert to a local data frame
dataframe <- tbl_df(dataframe.df)

#Display in full data frame
data.frame(head(dataframe))

# Display the text, fave status & number of faves for favorited & RT'd tweets

filteredframe <- variable %>%
  group_by(filteredframe, isRetweet) %>%
  select(text, favorited, favoriteCount)  %>%
  filter(filteredframe, isRetweet==TRUE)	

filteredframe
