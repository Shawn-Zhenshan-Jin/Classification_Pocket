########################
# Regularized Logistic Regression(Ridge)
########################
# note: 1.Sometimes can't just give one lambda, need to based on default automatically generated lambda 
#       2. The 100 lambda is automatically generated from glmnet, because of the different data in each fold, 
#          the lambda sequence is not totally the same
#       3. The true Optimal tunning parameter is close to the generated result
#       4. index of lambda chosen by model is opposite from index of corresponding predict value

foldNumber <- 5
trainFold <- 4
cvNumber <- ncol(combn(foldNumber, trainFold))
# lambdaRidge <- 1:100
# TuneParamRidge <- expand.grid(1:cvNumber, lambdaRidge)

## Initalize Parallel backend
cl <- parallel:::detectCores()
##*******change the number of cores in makeCluster *********
cl <- makeCluster((cl - 1))
registerDoSNOW(cl)

pb <- txtProgressBar(max = cvNumber, style = 3)
progress <- function(n) setTxtProgressBar(pb, n)
opts <- list(progress = progress)

## ridge in a parallel loop
MultiRidgeTuneResult <- foreach(i=1:cvNumber, .combine=rbind, .packages = 'glmnet', .options.snow = opts) %dopar% {
  ## 5-folds CV split data into training, testing and validation using seed 2
  dat = CvDataSplit(TrainX, TrainY, foldNumber, trainFold,i, seed = 2)
  
  ## train
  FitLogisticRidge <- glmnet(as.matrix(dat$trainX), factor(dat$trainY), family="multinomial", alpha = 0) 
  predLogisticTrainRidge <- predict(FitLogisticRidge, as.matrix(dat$trainX), type = "class")
  trainMSE <- apply(predLogisticTrainRidge, 2, function(x){ ClassificationError(table(x, dat$trainY))})
  
  ## validate
  predLogisticRidge <- predict(FitLogisticRidge, as.matrix(dat$validX), type = "class")
  validMSE <- apply(predLogisticRidge, 2, function(x){ ClassificationError(table(x, dat$validY))})
  
  ## tabulate results
  results = cbind(lamb = 1:length(validMSE),
                  trainMSE = rev(trainMSE),
                  validMSE = rev(validMSE))
}
stopCluster(cl)
close(pb)

MultiRidgeTuneResult <- as.data.frame(MultiRidgeTuneResult)
CVplot(MultiRidgeTuneResult, 'lamb', classification = T)
OptLambdaIdxRidge = MultiRidgeTuneResult$lamb[which.min(MultiRidgeTuneResult$validMSE)]

# Prediction for Multinomial with Ridge
TestMultiRidge <- glmnet(as.matrix(TrainX), factor(TrainY), family="multinomial", alpha = 0) 
TestPred <- predict(TestMultiRidge, as.matrix(TestX), type = "class")
classificTableMultiRidge <- table(TestPred[,(length(TestMultiRidge$lambda) - OptLambdaIdxRidge)], TestY)
ErrorMultiRidge <- ClassificationError(classificTableMultiRidge)
OptLambdaRidge <- TestMultiRidge$lambda[(length(TestMultiRidge$lambda) - OptLambdaIdxRidge)]
