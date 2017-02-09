############################
#
# Binary Model 
#
############################
source("load/load_binary.R")
source("package/package_binary.R")

############################
#
# Binary Model Fitting
#
############################
# Naive Baysian
source("model/binary/Naive_Baysian.R")
# KNN
source("model/binary/KNN.R")
# LDA
source("model/binary/LDA.R")
# # QDA(error with data set)
# source("model/binary/QDA.R")
# Naive logistic regression
source("model/binary/Naive_logistic_regression.R")
# Lasso logistic regression
source("model/binary/Lasso_logsitic_regression.R")
# Naive SVM
source("model/binary/Naive_SVM.R")
# Polynomial SVM
source("model/binary/Polynomial_SVM.R")
# Radial SVM
source("model/binary/Radial_SVM.R")
# Sigmoid SVm
source("model/binary/Sigmoid_SVM.R")

###########################
# Performance Visualization
source("model/binary/Model_comparison.R")

