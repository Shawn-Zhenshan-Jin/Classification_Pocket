########################
# Support Vector Machine(Linear without kernnel)
########################
# note: 1. input Response variable should be factor
#       2. build in automatic optimal parameter search is bad
#       3. Specify best tunning parameter by add additonal parameters
#       4. Cross validation: 5 folds, 80% training
# Action:
#       Linear SVM Cross validation with trainXY and test the generalized
#       performance with testInput and testOutput
# Input:
#       trainXY: First column as Y, the rest is X
#       costParam: list of cost parameters
########

#################
# One vs. One 
####
# Find the best tuning parameters
OneOne_SVM <- function(trainXY, testInput, testOutput, costParam, foldNumber  =5, trainFold= 4){
  library(e1071);source('source/ClassificationErrorSparse.R',local = TRUE)
  source('source/CvDataSplit.R',local = TRUE);source('source/CVplot.R')
  # trainXY <- TrainXY; testInput <- TestX; testOutput <- TestY
  # costParam <- 2^c(-8,-6,0)
  # foldNumber <- 5; trainFold <- 4
  cvNumber <- ncol(combn(foldNumber, trainFold))
  TuneParam <- expand.grid(1:cvNumber, costParam)
  
  ## Initalize Parallel backend
  core <- parallel:::detectCores()
  ##*******change the number of cores in makeCluster *********
  cl <- makeCluster(core - 1)
  registerDoSNOW(cl)
  
  pb <- txtProgressBar(max = length(costParam), style = 3)
  progress <- function(n) setTxtProgressBar(pb, n)
  opts <- list(progress = progress)
  
  ## EN in a parallel loop
  SVMTuneResult <- foreach(i=1:nrow(TuneParam), .combine=rbind, .packages ='e1071', .options.snow = opts) %dopar% {
    ## 5-folds CV split data into training, testing and validation using seed 2
    dat = CvDataSplit(trainXY[,2:ncol(trainXY)], trainXY[,1], foldNumber, trainFold,TuneParam[i,1], seed = 2)
    
    trainXY_CV <- cbind(dat$trainY, dat$trainX)
    names(trainXY_CV)[1] <- 'Y'
    ## train
    OO_cvSVM <- svm(Y ~., data = trainXY_CV,kernel = 'linear', cost = TuneParam[i,2], type = 'C-classification')
    predSVMTrain_OO <- predict(OO_cvSVM, as.matrix(dat$trainX), type = "class")
    trainMSE <- ClassificationErrorSparse(predSVMTrain_OO, dat$trainY)
    
    ## validate
    predSVMValid_OO <- predict(OO_cvSVM, as.matrix(dat$validX), type = "class")
    validMSE <- ClassificationErrorSparse(predSVMValid_OO, dat$validY)
    
    ## tabulate results
    results = cbind(CvIdx = TuneParam[i,1],
                    cost = TuneParam[i,2],
                    trainMSE = trainMSE,
                    validMSE = validMSE)
  }
  stopCluster(cl)
  close(pb)
  
  SVMTuneResult <- as.data.frame(SVMTuneResult)
  CVStuffSVM <- CVplot(SVMTuneResult, c('cost'), classification = TRUE, threeDPlot = FALSE)
  optimalTuneSVM_OO = CVStuffSVM$opatimalParams$cost

  # Fit the optimal tuning parameters
  TestSVM_OO <- svm(Y ~., data = trainXY,kernel = 'linear', cost = optimalTuneSVM_OO, type = 'C-classification')
  predSVM_OO <- predict(TestSVM_OO, testInput)

  classificTableSVM_OO <- table(predSVM_OO, testOutput)

  ErrorSVM_OO <- ClassificationErrorSparse(predSVM_OO, testOutput)

  list(ErrorSVM_OO = ErrorSVM_OO,
       optimalTuneSVM_OO = optimalTuneSVM_OO,
       confusionMatrix = classificTableSVM_OO,
       cvPlot = CVStuffSVM)
}