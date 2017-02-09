########################
# LDA
########################
FitLDA <- lda(ThreeEightTrainX, ThreeEightTrainY)
predLDA <- predict(FitLDA, ThreeEightTestX)
classificTableLDA <- table(predLDA$class, ThreeEightTestY)

ErrorLDA <- ClassificationError(classificTableLDA)