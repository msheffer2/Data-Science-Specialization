# Set working directory
################################################################################
setwd("c:\\repos\\Data-Science-Specialization\\")

# Load libraries
################################################################################
library(ggplot2)
library(dplyr)
#library(tidyr)
#library(caret)
#library(scales)
#Loaded explicitly = caret

################################################################################
# Predictor Importances
################################################################################
# Pull importance data from fit files and prep for plotting
# NOTE: Using C5.0 models because Naive Bayes does not offer importance measures
################################################################################

#Data Prep
load("./output/mod52.fit.xz")
imp5 <- caret::varImp(fit)$importance
imp5$word <- rownames(imp5)
imp5 <- imp5[1:20,]
imp5$model <- 1
rm(fit)

load("./output/mod12.fit.xz")
imp1 <- caret::varImp(fit)$importance
imp1$word <- rownames(imp1)
imp1 <- imp1[1:20,]
imp1$model <- 2
rm(fit)

imp_dat <- bind_rows(imp5, imp1)
imp_dat$model <- factor(imp_dat$model, levels=c(1:2), 
                        labels=c("5 Star", "1 Star"))
imp_dat <- arrange(imp_dat, desc(Overall), model)
save(imp_dat, file="./output/imp_dat.Rdata")
rm(imp1, imp5)

#Plot Data
imp_plot <- ggplot(imp_dat, aes(x=reorder(word, Overall), y=Overall, fill=model)) +
    facet_grid(. ~ model) + 
    scale_fill_manual(values=c("brown2", "cadetblue3")) +
    geom_bar(stat="identity") +
    coord_flip() +
    theme(text = element_text(size=15), 
          panel.grid.minor=element_blank(),
          panel.grid.major=element_blank(),
          legend.position="none") +
    labs(x="Word", y="Importance Score", title="Predictor Importance by Model")
imp_plot

ggsave("./output/imp_plot.pdf")
rm(imp_plot)


################################################################################
# Compare Important Word Frequency
################################################################################

#Data Prep
load("./data/moddat.Rdata")

word_dat <- select(moddat, fstar, ostar) %>%
  bind_cols(moddat[,unique(imp_dat$word)]) %>%
  mutate(star = ifelse(fstar == "Yes", 1, 2)) %>%
  mutate(star = ifelse(ostar == "Yes", 3, star)) %>%
  mutate(star = factor(star, levels=c(1:3), 
                       labels=c("5 Star", "Other Rating","1 Star")))%>%
  select(-fstar, -ostar) %>% 
  group_by(star) %>% 
  summarise_each(funs(mean)) %>%
  data.frame() %>%
  tidyr::gather(star)
names(word_dat) <- c("Rating", "word", "value")
save(word_dat, file="./output/word_dat.Rdata")

#Plot Data
word_bar <- ggplot(word_dat, aes(x=word, y=value, fill=Rating)) +
    scale_fill_manual(values=c("brown2", "dimgray", "cadetblue3")) +
    geom_bar(stat="identity", position="dodge") +
    theme(text = element_text(size=15), 
          panel.grid.minor=element_blank(),
          panel.grid.major=element_blank()) +
    labs(x="Word", y="Word Frequency", title="Word Frequency of Most Important Predictors by Rating")
word_bar

ggsave("./output/word_bar.pdf")
rm(moddat, imp_dat, word_dat, word_bar)


