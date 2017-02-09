########################
# Kernel Support Vector Machine
########################
# radial basis
cvSVMRadial <-  tune.svm(Y ~., data = ThreeEightTrainXY,kernel = 'radial', gamma = 2^c(-8, -4, 0, 2),cross = 5, fix = 4/5, type = 'C-classification')
plot(cvSVMRadial, main = 'Cross Validation for Radial SVM')

optimalTuneSVMRadial <- c(cvSVMRadial$best.model$gamma)
names(optimalTuneSVMRadial) <- c('gamma')
predSVMRadial <- predict(cvSVMRadial$best.model, ThreeEightTestX)
classificTableSVMRadial <- table(predSVMRadial, ThreeEightTestY)
ErrorSVMRadial <- ClassificationError(classificTableSVMRadial)
