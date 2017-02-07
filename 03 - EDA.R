# Set working directory
################################################################################
setwd("c:\\repos\\Data-Science-Specialization\\")

# Load libraries
################################################################################
library(dplyr)
library(ggplot2)
#Explicitly called = scales, car, tibble, caret

# Load & Prepare Data
################################################################################
if (exists("stardat")==FALSE){
  load("./data/stardat.Rdata") 
}

################################################################################
# Distribution of Star Rating
################################################################################

# Data Prep
bar1_dat <- stardat %>%
  mutate(stars = 5 - stars + 1) %>%
  mutate(stars = factor(stars, levels=c(1:5), 
                        labels=c("5 Stars", "4 Stars", "3 Stars", "2 Stars", "1 Star"))) %>%
  group_by(stars) %>% 
  summarize(count=n())

bar1_dat$labn <- paste(scales::comma_format()(bar1_dat$count))
bar1_dat$labp <- bar1_dat$count / sum(bar1_dat$count)
bar1_dat$labp <- paste(scales::percent_format()(bar1_dat$labp))
save(bar1_dat, file="./output/bar1_dat.Rdata")

# Plot
colors <- c("brown2", "dimgray", "dimgray", "dimgray", "cadetblue3") 

bar1 <- ggplot(bar1_dat, aes(x=stars, y=count)) + 
    geom_bar(stat="identity", color=colors, fill=colors) +
    geom_text(aes(label=labn), vjust=-1.5, color="black") +
    geom_text(aes(label=labp), vjust=1.5, color="white") +
    scale_y_continuous(labels = scales::comma) +
    theme(text = element_text(size=15), 
          panel.grid.minor=element_blank(),
          panel.grid.major=element_blank()) +
    ggtitle("Distribution of Star Ratings") +
    xlab("Rating") + ylab("# Reviews")
bar1

ggsave("./output/bar1_char.pdf")
rm(bar1_dat, bar1, colors)

################################################################################
# Distribution of Five Star & One Star in Train & Test
################################################################################

# Data Prep
bar2_dat <- select(stardat, stars, tflag) %>%
  mutate(train = 2 - tflag + 1) %>%
  mutate(train = factor(train, levels=c(1:2), 
                        labels=c("Test", "Train"))) %>%
  mutate(star = car::recode(stars, "1=2;2=3;3=3;4=3;5=1")) %>%
  mutate(star = factor(star, levels=c(1:3), 
                        labels=c("5 Star", "1 Star", "Other Rating"))) %>% 
  group_by(train, star) %>% 
  summarise(count=n())

bar2_dat$labp <- ifelse(bar2_dat$train == "Test", 
                      bar2_dat$count / sum(bar2_dat$count[bar2_dat$train=="Test"]),
                      bar2_dat$count / sum(bar2_dat$count[bar2_dat$train=="Train"]))
bar2_dat$labp <- paste(scales::percent_format()(bar2_dat$labp))
bar2_dat$labn <- paste(scales::comma_format()(bar2_dat$count))
save(bar2_dat, file="./output/bar2_dat.Rdata")

# Plot
colors <- c("brown2", "cadetblue3", "dimgray", "brown2", "cadetblue3", "dimgray") 

bar2 <- ggplot(bar2_dat, aes(x=star, y=count)) +
                  facet_grid(. ~ train) + 
    geom_bar(stat="identity", color=colors, fill=colors) +
    geom_text(aes(label=labn), vjust=-1.5, color="black") +
    geom_text(aes(label=labp), vjust=1.5, color="white") +
    scale_y_continuous(labels = scales::comma) +
    theme(text = element_text(size=15), 
          panel.grid.minor=element_blank(),
          panel.grid.major=element_blank()) +
    ggtitle("Distribution of Star Ratings for Train & Test Datasets") +
    xlab("") + ylab("# Reviews")
bar2

ggsave("./output/bar2_char.pdf")
rm(bar2, bar2_dat, stardat, colors)

################################################################################
# PCA of Words and Star Rating
################################################################################

# Data Prep
load("./data/moddat.Rdata")
pca_dat <- filter(moddat, fstar == "Yes" | ostar == "Yes") %>%
  mutate(star_rating = ifelse(fstar == "Yes", 1, 2)) %>%
  mutate(star_rating = factor(star_rating, levels=c(1:2), labels=c("5 Star", "1 Star"))) %>%
  select(-fstar, -ostar, -tflag)
groups <- select(pca_dat, star_rating)
pca_dat <- select(pca_dat, -star_rating)

# PCA with All Words
################################################################################
fit <- prcomp(pca_dat, center = TRUE, scale. = TRUE, tol=.1)

# Eigenvalues
################################################################################
evalues <- data.frame(eigenvalues=fit$sdev**2, 
                      pcomp=1:length(fit$sdev))
ggplot(evalues, aes(pcomp, eigenvalues)) + 
  geom_bar(stat="identity", fill="gray") + 
  geom_line()
rm(evalues)

# Display component statistics
################################################################################
plot(fit, type="l")

# Keep only top 30 rotated factors from first two components
################################################################################
rfactors <- data.frame(abs(fit$rotation[,1:2])) %>%
  tibble::rownames_to_column() %>%
  rename(name=rowname) %>%
  rowwise() %>%
  mutate(check = mean(c(PC1, PC2))) %>%
  ungroup() %>%
  mutate(check2 = ifelse(check > mean(check), 1, 0)) %>%
  filter(check2 == 1) %>%
  arrange(-check) %>%
  filter(row_number() <= 30) %>%
  select(name)
use <- rfactors$name

rm(fit, rfactors)

# Rerun PCA with smaller set of words
###############################################################################
fit <- prcomp(pca_dat[use], center = TRUE, scale. = TRUE, tol=.1)

# Restructure the data for plotting
################################################################################
pca_plot_dat <- data.frame(fit$x)[1:2] %>%
  mutate(groups = groups$star_rating)

#Thin the data for plotting
set.seed(3456)
look <- caret::createDataPartition(pca_plot_dat$groups, p=.1, list=FALSE)
pca_plot_dat <- pca_plot_dat[look,]

word_dat <- data.frame(cbind("PC1"=fit$rotation[,1], "PC2"=fit$rotation[,2]))
#Scale factor
sf <- min(((max(pca_plot_dat[,1]) - min(pca_plot_dat[,1]))/(max(word_dat[,1])-min(word_dat[,1]))), 
          ((max(pca_plot_dat[,2]) - min(pca_plot_dat[,2]))/(max(word_dat[,2])-min(word_dat[,2]))))
rm(pca_dat, groups, fit, use, look)

# Draw Map
################################################################################
pca <- ggplot(pca_plot_dat, aes_string(x="PC1", y="PC2")) + 
    geom_point(aes(colour=groups), alpha=.5) + 
    scale_colour_manual(values=c("brown2", "cadetblue3")) + 
    coord_equal() + 
    #Labels
    geom_text(data=word_dat, aes(x = word_dat$PC1 * sf * 0.82, 
                               y = word_dat$PC2  * sf * 0.82, 
                               label=rownames(word_dat)), 
              size = 6, vjust=1, color="black") + 
    #Arrows
    geom_segment(data=word_dat, aes(x = 0, y = 0, 
                                  xend = word_dat$PC1 * sf * 0.8, 
                                  yend = word_dat$PC2 * sf * 0.8), 
                 arrow = arrow(length = unit(.2, 'cm')), color = "grey30") + 
    theme(text = element_text(size=15), 
          panel.grid.minor=element_blank(),
          panel.grid.major=element_blank()) +
    labs(colour="Rating") + 
    ggtitle("Principal Components Map of Review Words by Star Rating")
pca

pca_plot_dat <- list(pca_plot_dat, word_dat, sf)
save(pca_plot_dat, file="./output/pca_plot_dat.Rdata")
ggsave("./output/pca_plot.pdf")

rm(pca_plot_dat, word_dat, groups, pca, sf, moddat)
