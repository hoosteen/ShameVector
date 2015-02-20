# create a new object "bad" that will hold missing data 
bad <- is.na(BB)

# return all missing elements
BB[bad]

# gsub substitutes punctuation with a space
BB$text<- gsub('[[:punct:]]', ' ', BB$text)

# gsub substitues character classes that do not
# give an output, such as feed, bckspce & tab w/space
BB$text<- gsub('[[:cntrl:]]', ' ', BB$text)

# gsub subs numerical values with digits >=1 w/' '
BB$text<- gsub('\\d+', ' ', BB$text)

# simplify the data frame by keeping the cleaned text, 
# year and concatenated version of year/month/day
BB.text <- as.data.frame(BB$text)
BB.text$year <- BB$year
BB.text$Date <- as.Date( paste(BB$year, 
                               BB$month, 
                               BB$day, sep = "-") ,
                         format = "%Y-%m-%d" )

BB.text$Date <- strptime(as.character(BB.text$Date),
                         "%Y-%m-%d")

# Reassign column names
colnames(BB.text) <- c("text", "year", "date")

