########################
# QDA
########################
FitQDA <- qda(TrainX, TrainY)
predQDA <- predict(FitQDA, TestX)
classificTableQDA<- table(predQDA$class, TestY)

ErrorQDA <- ClassificationError(classificTableQDA)
