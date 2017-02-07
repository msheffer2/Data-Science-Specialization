# Set working directory
################################################################################
setwd("c:\\repos\\Data-Science-Specialization\\")

# Load libraries
################################################################################
library(dplyr)
library(tm)
#Explicitly called = caret, beepr

# Load Data
################################################################################
if (exists("stardat")==FALSE){
  load("./data/stardat.Rdata") 
}

# Create Corpus
################################################################################
corpus <- Corpus(VectorSource(stardat$text))

# Clean Corpus - this is a long, slow process, corpus will be ~ 3.6 Gb RAM
################################################################################
#Remove non-ASCII characters, convert to lower case, remove punctuation marks,
#remove numbers, remove white space, remove common stopwords, stem the corpus,
#and convert to plain text

nonascii <- function(x) {
    iconv(x, "latin1", "ASCII", sub="")
} 

corpus <- tm_map(corpus, content_transformer(nonascii))
corpus <- tm_map(corpus, content_transformer(tolower)) 
corpus <- tm_map(corpus, content_transformer(removePunctuation))
corpus <- tm_map(corpus, content_transformer(removeNumbers))
corpus <- tm_map(corpus, content_transformer(stripWhitespace))
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stemDocument)
corpus <- tm_map(corpus, PlainTextDocument) 

rm(nonascii)
beepr::beep()

# Create & Clean Up Document-Term Matrix, Convert to Dichotomies
################################################################################
dtm <- DocumentTermMatrix(corpus)
print(dtm)
beepr::beep()

#Removing corpus to save RAM space
rm(corpus)

#Remove sparse terms
dtm <- removeSparseTerms(dtm, 0.95)
print(dtm)
beepr::beep()

#Convert to data frame
dtm <- as.data.frame(as.matrix(dtm))

#Remove words with zero variance
zv <- caret::nearZeroVar(dtm)
names(dtm[zv])
dtm <- select(dtm, -(zv))
rm(zv)

#Remove highly correlated words
corr <- cor(as.matrix(dtm))
highcorr <- caret::findCorrelation(corr, cutoff=.5)
length(highcorr)
dtm <- select(dtm, -(highcorr))
rm(highcorr, corr)

#Dichotomize data
dtm <- data.frame(apply(dtm, 2, function(x) ifelse(x > 0, 1, 0)))
save(dtm, file="./data/dtm.Rdata")

# Combine DTM & Star Dta
################################################################################
moddat <- bind_cols(stardat, dtm) %>%
  select(-text, -stars, -business_id, -review_id)

save(moddat, file="./data/moddat.Rdata")
rm(stardat, dtm)

# Create Train & Test Datasets
################################################################################
train <- filter(moddat, tflag == 1) %>% 
  select(-tflag)
save(train, file="./data/train.Rdata")
test <- filter(moddat, tflag == 2) %>% 
  select(-tflag)
save(test, file="./data/test.Rdata")
rm(moddat, test, train)





