# Set working directory
################################################################################
setwd("c:\\repos\\Data-Science-Specialization\\")

# Load libraries
################################################################################
library(dplyr)
#Explicitly called = readr, caret


# Convert data files to R format
################################################################################
# I used a Python script provided by Yelp to convert the json datasets to csv
# https://github.com/Yelp/dataset-examples

# Codeup for Business Dataset
################################################################################
#List of English-speaking cities/states for filtering
english_list <- c("AZ", "IL", "NC", "NV", "PA", "WI", "EDH", "FIF", "ELN", "KHL", 
                  "MLN", "NTH", "SCB", "XGL", "HAM", "ON")

#Read up data, filter to enligh-speaking only, select only restaurant reviews, 
#remove unneeded variables, remove duplicated ids
business <- readr::read_csv("./data/yelp_academic_dataset_business.csv") %>%
  filter(state %in% english_list) %>%
  filter(grepl("restaurant", tolower(categories))) %>%
  select(business_id, name) %>%
  distinct(business_id)

rm(english_list)

#Save tidied version
save(business, file="./data/business.Rdata")

# Codeup for Review Dataset
################################################################################

#Read up data, remove unneeded variables
review <- readr::read_csv("./data/yelp_academic_dataset_review.csv") %>%
  select(review_id, business_id, stars, text)

#Save tidied version
save(review, file="./data/review.Rdata")

# Merge Business & Review into One Dataset
# (will eliminate reviews not found in the filtered business dataset)
################################################################################
stardat <- inner_join(review, business, by="business_id")

rm(business, review)

#Create dependent variable based on 5 star (fstar) or 1 star (ostar) rating
stardat$fstar <- ifelse (stardat$stars == 5, 1, 2)
stardat$fstar <- factor(stardat$fstar, levels=c(1:2), labels=c("Yes", "No"))
stardat$ostar <- ifelse (stardat$stars == 1, 1, 2)
stardat$ostar <- factor(stardat$ostar, levels=c(1:2), labels=c("Yes", "No"))

# Create Train/Test Flag
################################################################################
set.seed(3456)
temp <- caret::createDataPartition(stardat$stars, p=.7, list=FALSE)

stardat$tflag <- 0
stardat[temp,]$tflag  <- 1; #Train
stardat[-temp,]$tflag <- 2; #Test

#Save tidied version
save(stardat, file="./data/stardat.Rdata")

#Remove temp dataset, stardat kept to be used in next step
rm(temp)




