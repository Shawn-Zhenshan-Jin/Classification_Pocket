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
ZipTrainY <- ZipTrain[,1]
ZipTrainX <- ZipTrain[,-1]
ZipTestY <- ZipTest[,1]
ZipTestX <- ZipTest[,-1]

# #data Processing
TrainXY <- cbind(as.factor(ZipTrainY), ZipTrainX)
colnames(TrainXY)[1] <- 'Y'
TrainX <- ZipTrainX
TrainY <- as.factor(ZipTrainY)
TestX <- ZipTestX
TestY <- as.factor(ZipTestY)

# Dealing with smaller dataset to increasing the running speed 
# can comment it to run the full dataset
rowNums <- 500
TrainXY <- TrainXY[1:rowNums,]
TrainX <- TrainX[1:rowNums,]
TrainY <- TrainY[1:rowNums]
TestX <- TestX[1:rowNums,]
TestY <- TestY[1:rowNums]
