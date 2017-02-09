########################
# Kernel Support Vector Machine
########################
# polynomial
cvSVMPoly <-  tune.svm(Y ~., data = ThreeEightTrainXY,kernel = 'polynomial', coef0 = 2^c(0.5,4,10), degree = c(2,3,4,5),cross = 5, fix = 4/5, type = 'C-classification')
plot(cvSVMPoly, main = 'Cross Validation for Polynomial SVM')

optimalTuneSVMPoly <- c(cvSVMPoly$best.model$degree, cvSVMPoly$best.model$coef0)
names(optimalTuneSVMPoly) <- c('degree', 'intercept')
predSVMPoly <- predict(cvSVMPoly$best.model, unname(as.matrix(ThreeEightTestX)))
classificTableSVMPoly <- table(predSVMPoly, ThreeEightTestY)
ErrorSVMPoly <- ClassificationError(classificTableSVMPoly)
