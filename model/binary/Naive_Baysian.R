######################
#
# Naive Baysian
#
######################
FitNaiveBay <- naiveBayes(ThreeEightTrainX, ThreeEightTrainY)
predNaiveBayRaw <- predict(FitNaiveBay, ThreeEightTestX, type="raw")
predNaiveBay <- sapply(predNaiveBayRaw[,1], function(prob3)if(prob3 >= 0.5) return(3)
                       else return(8))
classificTableNB <- table(predNaiveBay, ThreeEightTestY)

ErrorNaiveBay <- ClassificationError(classificTableNB)
