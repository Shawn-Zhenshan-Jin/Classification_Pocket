########################
# Naive Baysian
########################
FitNaiveBay <- naiveBayes(TrainX, TrainY)
predNaiveBay <- predict(FitNaiveBay, TestX, type="class")
classificTableNB <- table(predNaiveBay, TestY)
ErrorNaiveBay <- ClassificationError(classificTableNB)
