install.packages("Rcpp")
install.packages("wordcloud")
library(twitteR)
library(sentiment)
library(plyr)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)
require(RCurl)
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
apiKey <- "w7MlhSIReeYTP3El9gyXqA"
apiSecret <- "KEK2uRi9ZiVDcjA8XFzKlkI58tMuBoOSQpYEARhYY"
twitCred <- OAuthFactory$new(consumerKey=apiKey,consumerSecret=apiSecret,requestURL=reqURL,accessURL=accessURL,authURL=authURL)
twitCred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")) 
registerTwitterOAuth(twitCred)
rdmTweets <- userTimeline("narendramodi", n=2000)
df <- do.call("rbind", lapply(rdmTweets, as.data.frame))
dim(df)
library(tm)
myCorpus <- Corpus(VectorSource(df$text))
# convert to lower case
myCorpus <- tm_map(myCorpus, tolower)
# remove punctuation
myCorpus <- tm_map(myCorpus, removePunctuation)
# remove numbers
myCorpus <- tm_map(myCorpus, removeNumbers)
# remove URLs
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
myCorpus <- tm_map(myCorpus, removeURL)
# add two extra stop words: "available" and "via"
myStopwords <- c(stopwords('english'), "amp")
# remove "r" and "big" from stopwords
#### myStopwords <- setdiff(myStopwords, c("r", "big"))
# remove stopwords from corpus
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)
