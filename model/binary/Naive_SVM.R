########################
# Support Vector Machine
########################
# note: 1. input Response variable should be factor
#       2. build in automatic optimal parameter search is bad
#       3. Specify best tunning parameter by add additonal parameters
#       4. Cross validation: 5 folds, 60% training
ThreeEightTrainXY <- cbind(as.factor(ThreeEightTrainY), ThreeEightTrainX)
colnames(ThreeEightTrainXY)[1] <- 'Y'
cvSVM <-  tune.svm(Y ~., data = ThreeEightTrainXY,kernel = 'linear', cost = 2^c(-8,-6,-4,0,2),cross = 5, fix = 4/5, type = 'C-classification', probability = TRUE)

plot(cvSVM, main = 'Cross Validation for linear SVM')#, main = 'Cross Validation for Logsitic Regression with Lasso')

optimalTuneSVM <- cvSVM$best.model$cost
names(optimalTuneSVM) <- c('cost')

predSVM <- predict(cvSVM$best.model, newdata = ThreeEightTestX)
classificTableSVM <- table(predSVM, ThreeEightTestY)
ErrorSVM <- ClassificationError(classificTableSVM)