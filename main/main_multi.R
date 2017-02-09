############################
#
# Multi-Class Model 
#
############################
source("load/load_multi.R")
source("package/package_multi.R")

############################
#
# Multi-Class Model Fitting
#
############################
# SVM (one against one decision strategy)
source("model/multi/SVM_OneToOne.R")
# SVM (one against all decision strategy, necessary to run after one against one)
source("model/multi/SVM_OneToAll.R")
# Naive Baysian
source("model/multi/Naive_Baysian.R")
# LDA
source("model/multi/LDA.R")
# QDA
source("model/multi/QDA.R")
# Naive logsitic regression
source("model/multi/Naive_Logistic_Regression.R")
# Ridge logistic regression
source("model/multi/Ridge_Logistic_Regression.R")
# Lasso logistic regression
source("model/multi/Lasso_Logistic_Regression.R")
# Elastic Net logistic regression
source("model/multi/Elastic_Net_Logistic_Regression.R")

###########################
# Performance Comparison
source("model/multi/Model_comparison.R")
