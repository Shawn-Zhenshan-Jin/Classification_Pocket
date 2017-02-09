########################
# Support Vector Machine
########################
# note: 1. input Response variable should be factor
#       2. build in automatic optimal parameter search is bad
#       3. Specify best tunning parameter by add additonal parameters
#       4. Cross validation: 5 folds, 60% training
########

#################
# One vs. All 
####
# Main function: SVM in one against all strategy(Parallelized)
OneAll_SVM <- function(trainInput, trainOutput, testInput, testOutput, category_, cost){
  library(doSNOW);library(foreach);source('source/ClassificationError.R')
  
  #Helper function: grouping labels
  labelObservation <- function(inputX, outputY, category_){
    newCategory <- sapply(outputY, function(label) if(label == category_) return(TRUE)
                          else return(FALSE))
    newXY <- cbind(as.factor(newCategory), inputX)
    colnames(newXY)[1] <- 'Y'
    
    return(newXY)
  }
  
  #Currently only support one tuning parameter cost each time
  tuneParamSvmOA <- expand.grid(cost, category_)
  ## Initalize Parallel backend
  parallel:::detectCores()
  ##*******change the number of cores in makeCluster *********
  cl <- makeCluster(4)
  registerDoSNOW(cl)
  pb <- txtProgressBar(max = length(cat), style = 3)
  progress <- function(n) setTxtProgressBar(pb, n)
  opts <- list(progress = progress)
  
  ## ridge in a parallel loop
  oneAllSVMResult <- foreach(i=1:nrow(tuneParamSvmOA), .combine=cbind, .packages = 'e1071',.options.snow = opts) %dopar% {
    # Create data frame with binary labels
    binaryTrainXY <- labelObservation(trainInput, trainOutput, tuneParamSvmOA[i,2])
    binaryTestXY <- labelObservation(testInput, testOutput, tuneParamSvmOA[i,2])
    
    # Training
    fittedSvmOA <-  svm(Y ~., data = binaryTrainXY,kernel = 'linear', cost = tuneParamSvmOA[i,1], type = 'C-classification', decision.values = TRUE,probability = TRUE)
    # Testing
    predSvmOA <- predict(fittedSvmOA, binaryTestXY[,2:ncol(binaryTestXY)], decision.values = TRUE, probability = TRUE)
    # Return specific category probability
    as.data.frame(attr(predSvmOA, "probabilities"))$'TRUE'
  }
  stopCluster(cl)
  close(pb)
  
  classifiedCategoryOA <- apply(oneAllSVMResult, 1, function(obs){which.max(obs)})
  
  classificTableSVM_OA <- table(classifiedCategoryOA, TestY)
  
  list(ErrorSVM_OA = ClassificationError(classificTableSVM_OA),
       confusionMatrix = classificTableSVM_OA)
}
