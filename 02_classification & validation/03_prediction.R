#####################################################################################
###   split reference data into subsets of train data (70%) and test data (30%)   ###
#####################################################################################

set.seed(100)
dataIDs <- createDataPartition(extr$status, list=FALSE, p=0.7)
trainData <- extr[dataIDs,]
testData <- extr[-dataIDs,]


###################################################
###   define predictor and response variables   ###
###################################################

predictors <- names(rs)
response <- "status"


############################################################################################
###   train, print and plot RF detection model; plot importance of predictor variables   ###
############################################################################################

set.seed(100)
model <- train(trainData[, predictors], trainData[, response], method="rf", trControl=trainControl(method="cv"), importance=TRUE)
print(model)
plot(model)

plot(varImp(model), main=paste("Importance of predictor variables for RF detection model on 2019-07-24 (",sat,")", sep=""))


#############################################################
###   calculate spruce raster mask for model prediction   ###
#############################################################

spruceMask <- mask(rs, shapefile("./input/vector/ShapeFile/SWKKSL_spruce_without_windthrows.shp"))


#################################################################################################
###   perform model prediction on spruce raster mask and plot it; write output raster to disk ###
#################################################################################################

prediction <- predict(spruceMask, model)
spplot(prediction,col.regions=mycolor)

writeRaster(prediction, paste("./output/raster/",sat,"/",modelVariant,"_prediction.tif", sep=""), overwrite=TRUE)