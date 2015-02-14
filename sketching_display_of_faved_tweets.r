#Load Packages

library(dplyr)

#Display Data Frame
head(tmobile.df)

#Convert to a local data frame
tmobile <- tbl_df(tmobile.df)

#Display in full data frame
data.frame(head(tmobile))

# Display the text, fave status & number of faves for favorited tweets

filteredmobile <- tmobile %>%
  group_by(favorited) %>%
  select(text, favorited, favoriteCount)%>%
  filter(tmobile, favorited==TRUE)
