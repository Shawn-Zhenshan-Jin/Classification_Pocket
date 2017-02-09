# Data processing
library(data.table)

# Visualization
library(ggplot2)

# Model
library(e1071) #Naive baysian classifier
library(class) #
library(glmnet) #Logistic 

# Parallel Computating
library(foreach)
library(doSNOW)

# Other
library(MASS)

# Source file
source('source/CvDataSplit.R')
source('source/ClassificationError.R')
source('source/CVplot.R')