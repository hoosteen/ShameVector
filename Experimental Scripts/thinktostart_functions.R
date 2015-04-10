#Call libraries

library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(tm)
library(wordcloud)

#Define clean.text function

clean.text <- function(some_txt)
{
  some_txt = gsub("(RT|via)((?:\b\W*w+)+)", "", some_txt)
  some_txt = gsub("@\w+", "", some_txt)
  some_txt = gsub("[[:punct:]]", "", some_txt)
  some_txt = gsub("[[:digit:]]", "", some_txt)
  some_txt = gsub("http\w+", "", some_txt)
  some_txt = gsub("[ t]{2,}", "", some_txt)
  some_txt = gsub("^\s+|\s+$", "", some_txt)
  some_txt = gsub("amp", "", some_txt)
}

#Define "tolower error handling" function

try.tolower = function(x)
{
  y = NA
  try_error = tryCatch(tolower(x), error=function(e) e)
  if (!inherits(try_error, "error"))
    y = tolower(x)
  return(y)
}

getSentiment <- function(text, key){
  text <- URLencode(text);
  
  #save all the spaces, then get rid of stuff that breaks the API
}