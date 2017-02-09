########################
# Logistic Regression
########################
# note: 1.logistic regression take factor as response varaible
#       2.Sometimes can't just give one lambda, need to based on default automatically generated lambda
FitLogistic <- glmnet(as.matrix(TrainX), TrainY, family="multinomial")
predLogistic <- predict(FitLogistic, as.matrix(TestX), type = "class")
classificTableLogit <- table(predLogistic[,length(FitLogistic$lambda)], TestY)
ErrorLogistic <- ClassificationError(classificTableLogit)
