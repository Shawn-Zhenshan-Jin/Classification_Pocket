########################
# KNN
########################
foldNumber <- 5
trainFold <- 4
cvNumber <- ncol(combn(foldNumber, trainFold))
NearestNeighbor <- 1:5
TuneParam <- expand.grid(1:cvNumber, NearestNeighbor)

## Initalize Parallel backend
cl <- parallel:::detectCores()
##*******change the number of cores in makeCluster *********
cl <- makeCluster((cl - 1))
registerDoSNOW(cl)

pb <- txtProgressBar(max = length(NearestNeighbor), style = 3)
progress <- function(n) setTxtProgressBar(pb, n)
opts <- list(progress = progress)

## ridge in a parallel loop
KnnTuneResult <- foreach(i=1:nrow(TuneParam), .combine=rbind, .packages = 'class', .options.snow = opts) %dopar% {
  ## 5-folds CV split data into training, testing and validation using seed 2
  dat = CvDataSplit(TrainX, TrainY, foldNumber, trainFold,as.numeric(TuneParam[i,][1]), seed = 2)
  
  ## train
  TrainKNN <- knn(dat$trainX, dat$trainX, factor(dat$trainY), as.numeric(TuneParam[i,][2]))
  TrainTable <- table(TrainKNN, dat$trainY)
  ## validate
  ValidateKNN <- knn(dat$trainX, dat$validX, factor(dat$trainY), as.numeric(TuneParam[i,][2]))
  ValidateTable <- table(ValidateKNN, dat$validY)
  
  ## tabulate results
  results = cbind(cvIdx = TuneParam[i,1],
                  K = TuneParam[i,2],
                  trainMSE = ClassificationError(TrainTable),
                  validMSE = ClassificationError(ValidateTable))
}
stopCluster(cl)
close(pb)

KnnTuneResult <- as.data.frame(KnnTuneResult)
CVplot(KnnTuneResult, 'K', classification = T)
OptK = KnnTuneResult$K[which.min(KnnTuneResult$validMSE)]

# Prediction for KNN
TestKNN <- knn(TrainX, TestX, TrainY, OptK)
classificTableKNN <- table(TestKNN, TestY)
ErrorKNN <- ClassificationError(classificTableKNN)