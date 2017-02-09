########################
#KNN
########################
foldNumber <- 5; trainFold <- 4 # cross validation
cvNumber <- ncol(combn(foldNumber, trainFold))
NearestNeighbor <- 1:5 # tunning parameters
TuneParam <- expand.grid(1:cvNumber, NearestNeighbor)

KnnCV = lapply(c(1:nrow(TuneParam)), function(i) {
  ## 5-folds CV split data into training, testing and validation using seed 2
  dat = CvDataSplit(ThreeEightTrainX, ThreeEightTrainY, foldNumber, trainFold,as.numeric(TuneParam[i,][1]), seed = 2)
  ## train
  TrainKNN <- knn(dat$trainX, dat$trainX, factor(dat$trainY), as.numeric(TuneParam[i,][2]))
  TrainTable <- table(TrainKNN, dat$trainY)
  ## validate
  ValidateKNN <- knn(dat$trainX, dat$validX, factor(dat$trainY), as.numeric(TuneParam[i,][2]))
  ValidateTable <- table(ValidateKNN, dat$validY)
  
  list(trainError = ClassificationError(TrainTable),
       validError = ClassificationError(ValidateTable))
})
CVResult = matrix(unlist(KnnCV), ncol = 2, byrow = T)
KnnTuneResult = cbind(TuneParam, CVResult)
names(KnnTuneResult) = c("cvIdx", "K","trainMSE","validMSE")
CVplot(KnnTuneResult, 'K',classification = T)
OptK = KnnTuneResult$K[which.min(KnnTuneResult$validMSE)]

# Prediction for KNN
TestKNN <- knn(ThreeEightTrainX, ThreeEightTestX, factor(ThreeEightTrainY), OptK)
classificTableKNN <- table(TestKNN, ThreeEightTestY)
ErrorKNN <- ClassificationError(classificTableKNN)
