# Set working directory
################################################################################
setwd("c:\\repos\\Data-Science-Specialization\\")

# Load libraries
################################################################################
library(rpart)
library(randomForest)
library(gbm)
library(C50)
library(klaR)
library(caret)
library(pROC)
library(dplyr)
#Explicitly called = beepr

# Load Data
################################################################################
load("./data/train.Rdata")
train <- select(train, -fstar)

load("./data/test.Rdata")
test <- select(test, -fstar)

# Register Cores for any methods that can Parallel Process
################################################################################
library(doParallel)
detectCores()
registerDoParallel(makeCluster(detectCores()))

# Model 1
# Classification Tree - rpart 
################################################################################
#Fit the model
set.seed(23456)
fit <- rpart(ostar ~ ., 
             data=train, 
             method = "class", 
             control=rpart.control(xval = 10))
#Save the fit
save(fit, file="./output/mod11.fit.xz", compress="xz")

#Train Accuracy, Sensitivity, Specificity
pred_train <- predict(fit, train, type="class")
save(pred_train, file="./output/mod11_train.pred")

cm <- confusionMatrix(pred_train, train$ostar)
cm
save(cm, file="./output/mod11_train.cm")

#Train ROC, AUC
pred_train <- data.frame(predict(fit, train, type="prob")[,1])
roc <- roc(response=train$ostar, 
           predictor=pred_train$pred,
           levels=rev(levels(train$ostar)))
roc
save(roc, file="./output/mod11_train.roc")

#Test Accuracy, Sensitivity, Specificity
pred_test <- predict(fit, test, type="class")
save(pred_test, file="./output/mod11_test.pred")

cm <- confusionMatrix(pred_test, test$ostar)
cm
save(cm, file="./output/mod11_test.cm")

#Test ROC, AUC
pred_test <- data.frame(predict(fit, test, type="prob")[,1])
roc <- roc(response=test$ostar, 
           predictor=pred_test$pred,
           levels=rev(levels(test$ostar)))
roc
save(roc, file="./output/mod11_test.roc")

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
fit <- train(ostar ~ ., 
             data=train,
             method = "C5.0",
             trControl = fitControl,
             metric = "ROC",
             nthread = 8)
fit

#Save the fit
save(fit, file="./output/mod12.fit.xz", compress="xz")

#Train Accuracy, Sensitivity, Specificity
pred_train <- predict(fit, train, type="raw")
save(pred_train, file="./output/mod12_train.pred")

cm <- confusionMatrix(pred_train, train$ostar)
cm
save(cm, file="./output/mod12_train.cm")

#Train ROC, AUC
pred_train <- data.frame(predict(fit, train, type="prob")[,1])
roc <- roc(response=train$ostar, 
           predictor=pred_train$pred,
           levels=rev(levels(train$ostar)))
roc
save(roc, file="./output/mod12_train.roc")

#Test Accuracy, Sensitivity, Specificity
pred_test <- predict(fit, test, type="raw")
save(pred_test, file="./output/mod12_test.pred")

cm <- confusionMatrix(pred_test, test$ostar)
cm
save(cm, file="./output/mod12_test.cm")

#Test ROC, AUC
pred_test <- data.frame(predict(fit, test, type="prob")[,1])
roc <- roc(response=test$ostar, 
           predictor=pred_test$pred,
           levels=rev(levels(test$ostar)))
roc
save(roc, file="./output/mod12_test.roc")

beepr::beep()

rm(fit, pred_train, pred_test, cm, roc, fitControl)

# Model 3
# Random Forest 
################################################################################
#Fit the model
set.seed(23456)
fit <- randomForest(ostar ~ ., 
                    data=train, 
                    mtry=round(sqrt(ncol(train)-1), digits=0), 
                    importance = FALSE)
#Save the fit
save(fit, file="./output/mod13.fit.xz", compress="xz")

#Train Accuracy, Sensitivity, Specificity
pred_train <- predict(fit, train, type="class")
save(pred_train, file="./output/mod13_train.pred")

cm <- confusionMatrix(pred_train, train$ostar)
cm
save(cm, file="./output/mod13_train.cm")

#Train ROC, AUC
pred_train <- data.frame(predict(fit, train, type="prob")[,1])
roc <- roc(response=train$ostar, 
           predictor=pred_train$pred,
           levels=rev(levels(train$ostar)))
roc
save(roc, file="./output/mod13_train.roc")

#Test Accuracy, Sensitivity, Specificity
pred_test <- predict(fit, test, type="class")
save(pred_test, file="./output/mod13_test.pred")

cm <- confusionMatrix(pred_test, test$ostar)
cm
save(cm, file="./output/mod13_test.cm")

#Test ROC, AUC
pred_test <- data.frame(predict(fit, test, type="prob")[,1])
roc <- roc(response=test$ostar, 
           predictor=pred_test$pred,
           levels=rev(levels(test$ostar)))
roc
save(roc, file="./output/mod13_test.roc")

beepr::beep()

rm(fit, pred_train, pred_test, cm, roc)

# Model 4
# Bagged Tree 
################################################################################
#Fit the model
set.seed(23456)
fit <- randomForest(ostar ~ ., 
                    data=train, 
                    mtry=round(ncol(train) - 1, digits=0), 
                    importance = FALSE)
#Save the fit
save(fit, file="./output/mod14.fit.xz", compress="xz")

#Train Accuracy, Sensitivity, Specificity
pred_train <- predict(fit, train, type="class")
save(pred_train, file="./output/mod14_train.pred")

cm <- confusionMatrix(pred_train, train$ostar)
cm
save(cm, file="./output/mod14_train.cm")

#Train ROC, AUC
pred_train <- data.frame(predict(fit, train, type="prob")[,1])
roc <- roc(response=train$ostar, 
           predictor=pred_train$pred,
           levels=rev(levels(train$ostar)))
roc
save(roc, file="./output/mod14_train.roc")

#Test Accuracy, Sensitivity, Specificity
pred_test <- predict(fit, test, type="class")
save(pred_test, file="./output/mod14_test.pred")

cm <- confusionMatrix(pred_test, test$ostar)
cm
save(cm, file="./output/mod14_test.cm")

#Test ROC, AUC
pred_test <- data.frame(predict(fit, test, type="prob")[,1])
roc <- roc(response=test$ostar, 
           predictor=pred_test$pred,
           levels=rev(levels(test$ostar)))
roc
save(roc, file="./output/mod14_test.roc")

beepr::beep()

rm(fit, pred_train, pred_test, cm, roc)

# Model 5
# Gradient Boosting Machine
################################################################################
#Fit the model
set.seed(23456)
fit <- gbm(ostar ~ ., 
           data=train, 
           distribution="multinomial", 
           n.trees=500, 
           interaction.depth=2, 
           cv.folds=5,
           n.cores=8)

#Save the fit
save(fit, file="./output/mod15.fit.xz", compress="xz")

#Train Accuracy, Sensitivity, Specificity
pred_train <- predict(fit, train, type="response", n.trees=500)
pred_train <- apply(pred_train,1,function(i){which(i==max(i))})
pred_train <- factor(pred_train, levels=c(1:2), labels=c("Yes", "No"))
save(pred_train, file="./output/mod15_train.pred")

cm <- confusionMatrix(pred_train, train$ostar)
cm
save(cm, file="./output/mod15_train.cm")

#Train ROC, AUC
pred_train <- data.frame(predict(fit, train, type="response", n.trees=500))[,1]
roc <- roc(response=train$ostar, 
           predictor=pred_train,
           levels=rev(levels(train$ostar)))
roc
save(roc, file="./output/mod15_train.roc")

#Test Accuracy, Sensitivity, Specificity
pred_test <- predict(fit, test, type="response", n.trees=500)
pred_test <- apply(pred_test,1,function(i){which(i==max(i))})
pred_test <- factor(pred_test, levels=c(1:2), labels=c("Yes", "No"))
save(pred_test, file="./output/mod15_test.pred")

cm <- confusionMatrix(pred_test, test$ostar)
cm
save(cm, file="./output/mod15_test.cm")

#Test ROC, AUC
pred_test <- data.frame(predict(fit, test, type="response", n.trees=500))[,1]
roc <- roc(response=test$ostar, 
           predictor=pred_test,
           levels=rev(levels(test$ostar)))
roc
save(roc, file="./output/mod15_test.roc")

beepr::beep()

rm(fit, pred_train, pred_test, cm, roc)

# Model 6
# Naive Bayes
################################################################################
#Fit the model
set.seed(23456)
fit <- train(train, train$ostar,
             method = "nb",
             trControl = trainControl(method="none"),
             tuneGrid = data.frame(fL=0, usekernel=FALSE))
fit

#Save the fit
save(fit, file="./output/mod16.fit.xz", compress="xz")

#Train Accuracy, Sensitivity, Specificity
pred_train <- predict(fit, train, type="raw") 
save(pred_train, file="./output/mod16_train.pred")

cm <- confusionMatrix(pred_train, train$ostar)
cm
save(cm, file="./output/mod16_train.cm")

#Train ROC, AUC
pred_train <- data.frame(predict(fit, train, type="prob")[,1])
roc <- roc(response=train$ostar, 
           predictor=pred_train$pred,
           levels=rev(levels(train$ostar)))
roc
save(roc, file="./output/mod16_train.roc")

#Test Accuracy, Sensitivity, Specificity
pred_test <- predict(fit, test, type="raw")
save(pred_test, file="./output/mod16_test.pred")

cm <- confusionMatrix(pred_test, test$ostar)
cm
save(cm, file="./output/mod16_test.cm")

#Test ROC, AUC
pred_test <- data.frame(predict(fit, test, type="prob")[,1])
roc <- roc(response=test$ostar, 
           predictor=pred_test$pred,
           levels=rev(levels(test$ostar)))
roc
save(roc, file="./output/mod16_test.roc")

beepr::beep()

rm(fit, pred_train, pred_test, cm, roc)
