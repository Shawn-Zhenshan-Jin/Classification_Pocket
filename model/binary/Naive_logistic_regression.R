########################
# Logistic Regression
########################
# note: 1.  logistic regression only take TRUE/FALSE as response variable
#       2. Prediction return with probability 
FitLogistic <- glmnet(as.matrix(ThreeEightTrainX), as.vector(ThreeEightTrainY), family="binomial", lambda = 0) 
predLogistic <- predict(FitLogistic, as.matrix(ThreeEightTestX), type = "class")
classificTableLogit <- table(predLogistic, ThreeEightTestY)
ErrorLogistic <- ClassificationError(classificTableLogit)
