########################
# LDA
########################
FitLDA <- lda(TrainX, TrainY)
predLDA <- predict(FitLDA, TestX)
classificTableLDA <- table(predLDA$class, TestY)
ErrorLDA <- ClassificationError(classificTableLDA)
