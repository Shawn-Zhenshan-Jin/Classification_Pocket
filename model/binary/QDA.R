########################
# QDA
########################
FitQDA <- qda(ThreeEightTrainX, ThreeEightTrainY)
predQDA <- predict(FitQDA, ThreeEightTestX)
classificTableQDA<- table(predQDA$class, ThreeEightTestY)

ErrorQDA <- ClassificationError(classificTableQDA)