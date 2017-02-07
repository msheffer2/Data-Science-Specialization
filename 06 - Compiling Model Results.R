# Set working directory
################################################################################
setwd("c:\\repos\\Data-Science-Specialization\\")

# Load Libraries
################################################################################
library(scales)

compile_results <- function(x){
  results <- data.frame(matrix(0, nrow=6, ncol=9))
  colnames(results) <- c("Model", 
                         "Train Acc.", "Train Sens.", "Train Spec.", "Train AUC",
                         "Test Acc.", "Test Sens.", "Test Spec.", "Test AUC")
  results$Model <- c("CART", "C5.0", "Random Forest", "Bagged Tree", "GBM", "Naive Bayes")
  
  for (M in 1:6){
    WHICH <- (x * 10) + M
    
    load(paste0("./output/mod", WHICH, "_train.cm"))
    results[M,2] <- percent_format()(cm$overall[1])
    results[M,3] <- percent_format()(cm$byClass[1])
    results[M,4] <- percent_format()(cm$byClass[2])
    load(paste0("./output/mod", WHICH, "_train.roc"))
    results[M,5] <- percent_format()(roc$auc[1])
    rm(cm, roc)
    
    load(paste0("./output/mod", WHICH, "_test.cm"))
    results[M,6] <- percent_format()(cm$overall[1])
    results[M,7] <- percent_format()(cm$byClass[1])
    results[M,8] <- percent_format()(cm$byClass[2])
    load(paste0("./output/mod", WHICH, "_test.roc"))
    results[M,9] <- percent_format()(roc$auc[1])
    rm(cm, roc)
  }
  return(results)
}
results5 <- compile_results(5)
results1 <- compile_results(1)

save(results5, file="./output/results5.Rdata")
save(results1, file="./output/results1.Rdata")

rm(compile_results, results5, results1)


