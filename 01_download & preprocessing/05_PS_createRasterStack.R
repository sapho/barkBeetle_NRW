##################################################################################################
###   set variable for date and read raster data of study area's bounding box as RasterStack   ###
##################################################################################################

## date <- "20180419_20"
## PSstack <- stack("./output/raster/PlanetScope/PS_brick_20180419_20.grd")

## date <- "20190420_21"
## PSstack <- stack("./output/raster/PlanetScope/PS_brick_20190420_21.grd")

## date <- "20190724"
## PSstack <- stack("./output/raster/PlanetScope/PS_brick_20190724.grd")


############################
###   name band layers   ###
############################

names(PSstack)[1] <- "BLUE"
names(PSstack)[2] <- "GREEN"
names(PSstack)[3] <- "RED"
names(PSstack)[4] <- "NIR"


#########################################################################
###   calculate index layers, name them and add them to RasterStack   ###
#########################################################################

NDVI <- (PSstack$NIR-PSstack$RED)/(PSstack$NIR+PSstack$RED)
names(NDVI) <- "NDVI"
PSstack <- addLayer(PSstack, NDVI)

GNDVI <- (PSstack$NIR-PSstack$GREEN)/(PSstack$NIR+PSstack$GREEN)
names(GNDVI) <- "GNDVI"
PSstack <- addLayer(PSstack, GNDVI)

EVI <- 2.5*(PSstack$NIR-PSstack$RED)/(PSstack$NIR+6*PSstack$RED-7.5*PSstack$BLUE+1)
names(EVI) <- "EVI"
PSstack <- addLayer(PSstack, EVI)

CGM <- (PSstack$NIR/PSstack$GREEN) - 1
names(CGM) <- "CGM"
PSstack <- addLayer(PSstack, CGM)

CVI <- (PSstack$NIR*PSstack$RED/PSstack$GREEN^2)
names(CVI) <- "CVI"
PSstack <- addLayer(PSstack, CVI)


#####################################
###   write RasterStack to disk   ###
#####################################

if (date==20190724) {
  writeRaster(PSstack, paste("./output/raster/PlanetScope/PS_",date,"_9predictors-3m.grd", sep=""), overwrite=TRUE)
} else {
  writeRaster(PSstack, paste("./output/raster/PlanetScope/PS_",date,".grd", sep=""), overwrite=TRUE)
}