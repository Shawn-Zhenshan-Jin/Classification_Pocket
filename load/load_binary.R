##################################
#
# Zip code data set:
#           info: https://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/zip.info.txt
#           data: 
#             training:https://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/zip.train.gz
#             testing:https://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/zip.test.gz
#
##################################
ZipTrain <- fread('data/ZipCode/zip.train', header=F, stringsAsFactors=F, data.table=F)
ZipTest <- fread('data/ZipCode/zip.test', header=F, stringsAsFactors=F, data.table=F)

# Split Y and X from the original data set
ZipTrainY <- ZipTrain[,1]
ZipTrainX <- ZipTrain[,-1]
ZipTestY <- ZipTest[,1]
ZipTestX <- ZipTest[,-1]

# Data Processing 
ScaleZipTrainX <- scale(ZipTrainX, center = TRUE, scale = TRUE)
ScaleZipTestX <- scale(ZipTestX, center = TRUE, scale = TRUE)

########################
#Filtering Data for binary classification(3&8)
########################
ThreeEightIndicatorTr <- sapply(ZipTrainY, function(zipNumber) if (zipNumber %in% c(3,8)) return(TRUE)
                                else return(FALSE))
ThreeEightTrainX <- ZipTrainX[ThreeEightIndicatorTr,]
ThreeEightTrainY <- ZipTrainY[ThreeEightIndicatorTr]

ThreeEightIndicatorTs <- sapply(ZipTestY, function(zipNumber) if (zipNumber %in% c(3,8)) return(TRUE)
                                else return(FALSE))
ThreeEightTestX <- ZipTestX[ThreeEightIndicatorTs,]
ThreeEightTestY <- ZipTestY[ThreeEightIndicatorTs]

# Dealing with smaller dataset to speed up the modeling process
# Can comment it to run full dataset
rowNums <- 500
TrainXY <- TrainXY[1:rowNums,]
ThreeEightTrainX <- ThreeEightTrainX[1:rowNums,]
ThreeEightTrainY <- ThreeEightTrainY[1:rowNums]
ThreeEightTestX <- ThreeEightTestX[1:rowNums,]
ThreeEightTestY <- ThreeEightTestY[1:rowNums]

