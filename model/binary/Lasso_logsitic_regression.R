########################
# Regularized Logistic Regression(Lasso)
########################
# Reaosn: Large number of variabels compared to observations, wanna get more sparsity in the input data
# note: 1. glmnet/glmnet.cv only take matrix as X 

# Cross Validation
cvLogisticLasso <- cv.glmnet(as.matrix(ThreeEightTrainX), as.vector(ThreeEightTrainY), family="binomial", alpha = 1, nfolds = 5)
plot(cvLogisticLasso, main = 'Cross Validation for Logsitic Regression with Lasso')
OptLambda <- cvLogisticLasso$lambda[which.min(cvLogisticLasso$cvm)]

# Fit optimal tuning parameters
FitLogisticLasso <- glmnet(as.matrix(ThreeEightTrainX), as.vector(ThreeEightTrainY), family="binomial", alpha = 1, lambda = OptLambda) 
predLogisticLasso <- predict(FitLogisticLasso, as.matrix(ThreeEightTestX), type = "class")
classificTableLogitLasso <- table(predLogisticLasso, ThreeEightTestY)
ErrorLogisticLasso <- ClassificationError(classificTableLogitLasso)
