########################################################################
###   read raster data of study area's bounding box as RasterStack   ###
########################################################################

S2native <- stack("./output/raster/Sentinel-2/S2_20190724_19predictors-10m.grd")

PSnative <- stack("./output/raster/PlanetScope/PS_20190724_9predictors-3m.grd")


##################################################################################################################
###   drop layers from native S2 RasterStack for model variant S2_9predictors-10m; write RasterStack to disk   ###
##################################################################################################################

S2stack_20190724_9predictors10m <- dropLayer(S2native, names(dropLayer(S2native, names(PSnative))))

writeRaster(S2stack_20190724_9predictors10m, "./output/raster/Sentinel-2/S2_20190724_9predictors-10m.grd", overwrite=TRUE)


##########################################################################################################
###   resample native PS RasterStack for model variant PS_9predictors-10m; write RasterStack to disk   ###
##########################################################################################################

PSstack_20190724_9predictors10m <- resample(PSnative, S2native)

writeRaster(PSstack_20190724_9predictors10m, "./output/raster/PlanetScope/PS_20190724_9predictors-10m.grd", overwrite=TRUE)