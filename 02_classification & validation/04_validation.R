####################################################################################################
###   calculate confusion matrix and statistics for test error using the independent test data   ###
####################################################################################################

test_pred <- predict(model,testData)
confusionMatrix(test_pred, factor(testData$status))


####################################################################################################
###   determine probability of detection, probability of false detection and false alarm ratio   ###
####################################################################################################

vectorizedPrediction <- rasterToPolygons(prediction)
vectorizedPrediction <- as(vectorizedPrediction, 'sf')

st_agr(refData) = "constant"
st_agr(vectorizedPrediction) = "constant"
isectData <- st_intersection(refData, vectorizedPrediction)

prd_vals <- factor(isectData$layer, levels=c(1, 2))
obs_vals <- factor(isectData$status, levels=c("infested", "not_infested"))

result <- classificationStats(prd_vals, obs_vals)
result