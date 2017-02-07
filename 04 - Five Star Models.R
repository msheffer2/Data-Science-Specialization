# Set working directory
################################################################################
setwd("c:\\repos\\Data-Science-Specialization\\")

# Load libraries
################################################################################
library(dplyr)
library(doParallel)
library(caret)
library(pROC)
library(rpart)
library(C50)
library(randomForest)
library(gbm)
#Explicitly called = beepr

# Load Data
################################################################################
load("./data/train.Rdata")
train <- select(train, -ostar)

load("./data/test.Rdata")
test <- select(test, -ostar)


# Register Cores for any methods that can Parallel Process
################################################################################
detectCores()
registerDoParallel(makeCluster(detectCores()))

# Model 1
# Classification Tree - rpart 
################################################################################
#Fit the model
set.seed(23456)
fit <- rpart(fstar ~ ., 
             data=train, 
             method = "class", 
             control=rpart.control(xval = 10))
#Save the fit
save(fit, file="./output/mod51.fit.xz", compress="xz")

#Train Accuracy, Sensitivity, Specificity
pred_train <- predict(fit, train, type="class")
save(pred_train, file="./output/mod51_train.pred")

cm <- confusionMatrix(pred_train, train$fstar)
cm
save(cm, file="./output/mod51_train.cm")

#Train ROC, AUC
pred_train <- data.frame(predict(fit, train, type="prob")[,1])
roc <- roc(response=train$fstar, 
           predictor=pred_train$pred,
           levels=rev(levels(train$fstar)))
roc
save(roc, file="./output/mod51_train.roc")

#Test Accuracy, Sensitivity, Specificity
pred_test <- predict(fit, test, type="class")
save(pred_test, file="./output/mod51_test.pred")

cm <- confusionMatrix(pred_test, test$fstar)
cm
save(cm, file="./output/mod51_test.cm")

#Test ROC, AUC
pred_test <- data.frame(predict(fit, test, type="prob")[,1])
roc <- roc(response=test$fstar, 
           predictor=pred_test$pred,
           levels=rev(levels(test$fstar)))
roc
save(roc, file="./output/mod51_test.roc")

beepr::beep()

rm(fit, pred_train, pred_test, cm, roc)

# Model 2
# Classification Tree - C5.0 
################################################################################
#Fit the model
fitControl <- trainControl(method = "cv", 
                           number = 5, 
                           returnResamp= "all",
                           allowParallel = TRUE, 
                           classProbs = TRUE, 
                           summaryFunction=twoClassSummary)

set.seed(23456)
fit <- train(fstar ~ ., 
             data=train,
             method = "C5.0",
             trControl = fitControl,
             metric = "ROC",
             nthread = 8)
fit

#Save the fit
save(fit, file="./output/mod52.fit.xz", compress="xz")

#Train Accuracy, Sensitivity, Specificity
pred_train <- predict(fit, train, type="raw")
save(pred_train, file="./output/mod52_train.pred")

cm <- confusionMatrix(pred_train, train$fstar)
cm
save(cm, file="./output/mod52_train.cm")

#Train ROC, AUC
pred_train <- data.frame(predict(fit, train, type="prob")[,1])
roc <- roc(response=train$fstar, 
           predictor=pred_train$pred,
           levels=rev(levels(train$fstar)))
roc
save(roc, file="./output/mod52_train.roc")

#Test Accuracy, Sensitivity, Specificity
pred_test <- predict(fit, test, type="raw")
save(pred_test, file="./output/mod52_test.pred")

cm <- confusionMatrix(pred_test, test$fstar)
cm
save(cm, file="./output/mod52_test.cm")

#Test ROC, AUC
pred_test <- data.frame(predict(fit, test, type="prob")[,1])
roc <- roc(response=test$fstar, 
           predictor=pred_test$pred,
           levels=rev(levels(test$fstar)))
roc
save(roc, file="./output/mod52_test.roc")

beepr::beep()

rm(fit, pred_train, pred_test, cm, roc, fitControl)

# Model 3
# Random Forest 
################################################################################
#Fit the model
set.seed(23456)
fit <- randomForest(fstar ~ ., 
                    data=train, 
                    mtry=round(sqrt(ncol(train)-1), digits=0), 
                    importance = FALSE)
#Save the fit
save(fit, file="./output/mod53.fit.xz", compress="xz")

#Train Accuracy, Sensitivity, Specificity
pred_train <- predict(fit, train, type="class")
save(pred_train, file="./output/mod53_train.pred")

cm <- confusionMatrix(pred_train, train$fstar)
cm
save(cm, file="./output/mod53_train.cm")

#Train ROC, AUC
pred_train <- data.frame(predict(fit, train, type="prob")[,1])
roc <- roc(response=train$fstar, 
           predictor=pred_train$pred,
           levels=rev(levels(train$fstar)))
roc
save(roc, file="./output/mod53_train.roc")

#Test Accuracy, Sensitivity, Specificity
pred_test <- predict(fit, test, type="class")
save(pred_test, file="./output/mod53_test.pred")

cm <- confusionMatrix(pred_test, test$fstar)
cm
save(cm, file="./output/mod53_test.cm")

#Test ROC, AUC
pred_test <- data.frame(predict(fit, test, type="prob")[,1])
roc <- roc(response=test$fstar, 
           predictor=pred_test$pred,
           levels=rev(levels(test$fstar)))
roc
save(roc, file="./output/mod53_test.roc")

beepr::beep()

rm(fit, pred_train, pred_test, cm, roc)

# Model 4
# Bagged Tree 
################################################################################
#Fit the model
set.seed(23456)
fit <- randomForest(fstar ~ ., 
                    data=train, 
                    mtry=round(ncol(train) - 1, digits=0), 
                    importance = FALSE)
#Save the fit
save(fit, file="./output/mod54.fit.xz", compress="xz")

#Train Accuracy, Sensitivity, Specificity
pred_train <- predict(fit, train, type="class")
save(pred_train, file="./output/mod54_train.pred")

cm <- confusionMatrix(pred_train, train$fstar)
cm
save(cm, file="./output/mod54_train.cm")

#Train ROC, AUC
pred_train <- data.frame(predict(fit, train, type="prob")[,1])
roc <- roc(response=train$fstar, 
           predictor=pred_train$pred,
           levels=rev(levels(train$fstar)))
roc
save(roc, file="./output/mod54_train.roc")

#Test Accuracy, Sensitivity, Specificity
pred_test <- predict(fit, test, type="class")
save(pred_test, file="./output/mod54_test.pred")

cm <- confusionMatrix(pred_test, test$fstar)
cm
save(cm, file="./output/mod54_test.cm")

#Test ROC, AUC
pred_test <- data.frame(predict(fit, test, type="prob")[,1])
roc <- roc(response=test$fstar, 
           predictor=pred_test$pred,
           levels=rev(levels(test$fstar)))
roc
save(roc, file="./output/mod54_test.roc")

beepr::beep()

rm(fit, pred_train, pred_test, cm, roc)

# Model 5
# Gradient Boosting Machine
################################################################################
#Fit the model
set.seed(23456)
fit <- gbm(fstar ~ ., 
           data=train, 
           distribution="multinomial", 
           n.trees=500, 
           interaction.depth=2, 
           cv.folds=5,
           n.cores=8)

#Save the fit
save(fit, file="./output/mod55.fit.xz", compress="xz")

#Train Accuracy, Sensitivity, Specificity
pred_train <- predict(fit, train, type="response", n.trees=500)
pred_train <- apply(pred_train,1,function(i){which(i==max(i))})
pred_train <- factor(pred_train, levels=c(1:2), labels=c("Yes", "No"))
save(pred_train, file="./output/mod55_train.pred")

cm <- confusionMatrix(pred_train, train$fstar)
cm
save(cm, file="./output/mod55_train.cm")

#Train ROC, AUC
pred_train <- data.frame(predict(fit, train, type="response", n.trees=500))[,1]
roc <- roc(response=train$fstar, 
           predictor=pred_train,
           levels=rev(levels(train$fstar)))
roc
save(roc, file="./output/mod55_train.roc")

#Test Accuracy, Sensitivity, Specificity
pred_test <- predict(fit, test, type="response", n.trees=500)
pred_test <- apply(pred_test,1,function(i){which(i==max(i))})
pred_test <- factor(pred_test, levels=c(1:2), labels=c("Yes", "No"))
save(pred_test, file="./output/mod55_test.pred")

cm <- confusionMatrix(pred_test, test$fstar)
cm
save(cm, file="./output/mod55_test.cm")

#Test ROC, AUC
pred_test <- data.frame(predict(fit, test, type="response", n.trees=500))[,1]
roc <- roc(response=test$fstar, 
           predictor=pred_test,
           levels=rev(levels(test$fstar)))
roc
save(roc, file="./output/mod55_test.roc")

beepr::beep()

rm(fit, pred_train, pred_test, cm, roc)

# Model 6
# Naive Bayes
################################################################################
#Fit the model
set.seed(23456)
fit <- train(train, train$fstar,
             method = "nb",
             trControl = trainControl(method="none"),
             tuneGrid = data.frame(fL=0, usekernel=FALSE, adjust=0))
fit

#Save the fit
save(fit, file="./output/mod56.fit.xz", compress="xz")

#Train Accuracy, Sensitivity, Specificity
pred_train <- predict(fit, train, type="raw") 
save(pred_train, file="./output/mod56_train.pred")

cm <- confusionMatrix(pred_train, train$fstar)
cm
save(cm, file="./output/mod56_train.cm")

#Train ROC, AUC
pred_train <- data.frame(predict(fit, train, type="prob")[,1])
roc <- roc(response=train$fstar, 
           predictor=pred_train$pred,
           levels=rev(levels(train$fstar)))
roc
save(roc, file="./output/mod56_train.roc")

#Test Accuracy, Sensitivity, Specificity
pred_test <- predict(fit, test, type="raw")
save(pred_test, file="./output/mod56_test.pred")

cm <- confusionMatrix(pred_test, test$fstar)
cm
save(cm, file="./output/mod56_test.cm")

#Test ROC, AUC
pred_test <- data.frame(predict(fit, test, type="prob")[,1])
roc <- roc(response=test$fstar, 
           predictor=pred_test$pred,
           levels=rev(levels(test$fstar)))
roc
save(roc, file="./output/mod56_test.roc")

beepr::beep()

rm(fit, pred_train, pred_test, cm, roc)
