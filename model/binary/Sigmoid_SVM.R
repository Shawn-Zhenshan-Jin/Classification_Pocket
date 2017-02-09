########################
# Kernel Support Vector Machine
########################
# sigmoid
cvSVMSig <-  tune.svm(Y ~., data = ThreeEightTrainXY,kernel = 'sigmoid', coef0 = 2^c(-4,0.5,1,2), cross = 5, fix = 4/5, type = 'C-classification')
plot(cvSVMSig, main = 'Cross Validation for Sigmoid SVM')

optimalTuneSVMSig <- c(cvSVMSig$best.model$coef0)
names(optimalTuneSVMSig) <- c('intercept')
predSVMSig <- predict(cvSVMSig$best.model, ThreeEightTestX)
classificTableSVMSig <- table(predSVMSig, ThreeEightTestY)
ErrorSVMSig <- ClassificationError(classificTableSVMSig)