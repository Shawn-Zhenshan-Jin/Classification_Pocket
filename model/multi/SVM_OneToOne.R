########################
# Support Vector Machine
########################
#################
# One vs. One
####
# Fiting the mode based on best tuning from One vs. One
source('source/Multi-Class/OneOne_SVM.R')
costTun <- 2^c(-8,-6,-4,-2,0,1,2)
OneOneResult <- OneOne_SVM(TrainXY, TestX, TestY, costTun)
ErrorSVM_OO <- OneOneResult$ErrorSVM_OO
optimalTuneSVM_OO <- OneOneResult$optimalTuneSVM_OO
ConfusionMatrix_OO <- OneOneResult$confusionMatrix