########################
# Support Vector Machine
########################
#################
# One vs. All
####
source('source/Multi-Class/OneAll_SVM.R')
# Fiting the mode based on best tuning from One vs. One
cost <- optimalTuneSVM_OO
category <- 0:9
OneAllResult <- OneAll_SVM(TrainX, TrainY, TestX, TestY, category, cost)
ErrorSVM_OA <- OneAllResult$ErrorSVM_OA
ConfusionMatrix_OA <- OneAllResult$confusionMatrix