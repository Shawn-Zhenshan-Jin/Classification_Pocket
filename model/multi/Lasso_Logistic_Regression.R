########################
# Regularized Logistic Regression(Lasso)
########################
foldNumber <- 5
trainFold <- 4
cvNumber <- ncol(combn(foldNumber, trainFold))
# lambdaLasso <- 1:100
# TuneParamLasso <- expand.grid(1:cvNumber, lambdaLasso)

## Initalize Parallel backend
cl <- parallel:::detectCores()
##*******change the number of cores in makeCluster *********
cl <- makeCluster((cl - 1))
registerDoSNOW(cl)

pb <- txtProgressBar(max = cvNumber, style = 3)
progress <- function(n) setTxtProgressBar(pb, n)
opts <- list(progress = progress)

## Lasso in a parallel loop
MultiLassoTuneResult <- foreach(i=1:cvNumber, .combine=rbind, .packages = 'glmnet', .options.snow = opts) %dopar% {
  ## 5-folds CV split data into training, testing and validation using seed 2
  dat = CvDataSplit(TrainX, TrainY, foldNumber, trainFold,i, seed = 2)
  
  ## train
  FitLogisticLasso <- glmnet(as.matrix(dat$trainX), factor(dat$trainY), family="multinomial", alpha = 1) 
  predLogisticTrainLasso <- predict(FitLogisticLasso, as.matrix(dat$trainX), type = "class")
  trainMSE <- apply(predLogisticTrainLasso, 2, function(x){ ClassificationError(table(x, dat$trainY))})
  
  ## validate
  predLogisticLasso <- predict(FitLogisticLasso, as.matrix(dat$validX), type = "class")
  validMSE <- apply(predLogisticLasso, 2, function(x){ ClassificationError(table(x, dat$validY))})
  
  ## tabulate results
  results = cbind(lamb = 1:length(validMSE),
                  trainMSE = rev(trainMSE),
                  validMSE = rev(validMSE))
}
stopCluster(cl)
close(pb)

MultiLassoTuneResult <- as.data.frame(MultiLassoTuneResult)
CVplot(MultiLassoTuneResult, 'lamb', classification = T)
OptLambdaIdxLasso = MultiLassoTuneResult$lamb[which.min(MultiLassoTuneResult$validMSE)]

# Prediction for Multinomial with Lasso
TestMultiLasso <- glmnet(as.matrix(TrainX), factor(TrainY), family="multinomial", alpha = 1) 
TestPred <- predict(TestMultiLasso, as.matrix(TestX), type = "class")
classificTableMultiLasso <- table(TestPred[,(length(TestMultiLasso$lambda) - OptLambdaIdxLasso)], TestY)
ErrorMultiLasso <- ClassificationError(classificTableMultiLasso)
OptLambdaLasso <- TestMultiLasso$lambda[(length(TestMultiLasso$lambda) - OptLambdaIdxLasso)]
