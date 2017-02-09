########################
# Regularized Logistic Regression(EN)
########################
foldNumber <- 5
trainFold <- 4
cvNumber <- ncol(combn(foldNumber, trainFold))
# lambdaEN <- 1:100
alphaEN <- c(0.1,0.3,0.6,0.9)
TuneParamEN <- expand.grid(1:cvNumber, alphaEN)

## Initalize Parallel backend
parallel:::detectCores()
##*******change the number of cores in makeCluster *********
cl <- makeCluster(4)
registerDoSNOW((cl-1))

pb <- txtProgressBar(max = length(alphaEN), style = 3)
progress <- function(n) setTxtProgressBar(pb, n)
opts <- list(progress = progress)

## EN in a parallel loop
MultiENTuneResult <- foreach(i=1:nrow(TuneParamEN), .combine=rbind, .packages = 'glmnet', .options.snow = opts) %dopar% {
  ## 5-folds CV split data into training, testing and validation using seed 2
  dat = CvDataSplit(TrainX, TrainY, foldNumber, trainFold,TuneParamEN[i,1], seed = 2)
  
  ## train
  FitLogisticEN <- glmnet(as.matrix(dat$trainX), factor(dat$trainY), family="multinomial", alpha = TuneParamEN[i,2]) 
  predLogisticTrainEN <- predict(FitLogisticEN, as.matrix(dat$trainX), type = "class")
  trainMSE <- apply(predLogisticTrainEN, 2, function(x){ ClassificationError(table(x, dat$trainY))})
  
  ## validate
  predLogisticEN <- predict(FitLogisticEN, as.matrix(dat$validX), type = "class")
  validMSE <- apply(predLogisticEN, 2, function(x){ ClassificationError(table(x, dat$validY))})
  
  ## tabulate results
  results = cbind(lamb = 1:length(validMSE),
                  alpha = rep(TuneParamEN[i,1], times = length(validMSE)),
                  trainMSE = rev(trainMSE),
                  validMSE = rev(validMSE))
}
stopCluster(cl)
close(pb)

MultiENTuneResult <- as.data.frame(MultiENTuneResult)
CVplot(MultiENTuneResult, c('lamb'), classification = T) # 'alpha'
OptLambdaIdxENlamb = MultiENTuneResult$lamb[which.min(MultiENTuneResult$validMSE)]
OptLambdaIdxENAlpha = MultiENTuneResult$alpha[which.min(MultiENTuneResult$validMSE)]

# Prediction for Multinomial with EN
TestMultiEN <- glmnet(as.matrix(TrainX), factor(TrainY), family="multinomial", alpha = alphaEN[OptLambdaIdxENAlpha]) 
TestPred <- predict(TestMultiEN, as.matrix(TestX), type = "class")
classificTableMultiEN <- table(TestPred[,(length(TestMultiEN$lambda) - OptLambdaIdxENlamb)], TestY)
ErrorMultiEN <- ClassificationError(classificTableMultiEN)
OptLambdaEN <- TestMultiEN$lambda[(length(TestMultiEN$lambda) - OptLambdaIdxENlamb)]
