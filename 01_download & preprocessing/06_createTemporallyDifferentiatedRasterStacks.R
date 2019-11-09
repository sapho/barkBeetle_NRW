###############################################################################################
###   read S2 raster data of study area's bounding box from 2018 and 2019 as RasterStacks   ###
###############################################################################################

S2stack20180420 <- stack("./output/raster/Sentinel-2/S2_20180420.grd")
S2stack20190420 <- stack("./output/raster/Sentinel-2/S2_20190420.grd")


####################################################################
###   subtract S2 RasterStack of 2018 from RasterStack of 2019   ###
####################################################################

S2stackDiff <- S2stack20190420 - S2stack20180420


###################################################################
###   name layers of temporally differentiated S2 RasterStack   ###
###################################################################

names(S2stackDiff)[1] <- "BLUE"
names(S2stackDiff)[2] <- "GREEN"
names(S2stackDiff)[3] <- "RED"
names(S2stackDiff)[4] <- "VEG_RE_1"
names(S2stackDiff)[5] <- "VEG_RE_2"
names(S2stackDiff)[6] <- "VEG_RE_3"
names(S2stackDiff)[7] <- "NIR"
names(S2stackDiff)[8] <- "NARROW_NIR"
names(S2stackDiff)[9] <- "SWIR_1"
names(S2stackDiff)[10] <- "SWIR_2"
names(S2stackDiff)[11] <- "NDVI"
names(S2stackDiff)[12] <- "GNDVI"
names(S2stackDiff)[13] <- "EVI"
names(S2stackDiff)[14] <- "CGM"
names(S2stackDiff)[15] <- "CVI"
names(S2stackDiff)[16] <- "CIRE"
names(S2stackDiff)[17] <- "NDRE1"
names(S2stackDiff)[18] <- "NDRE2"
names(S2stackDiff)[19] <- "DWSI"


##################################################################
###   write temporally differentiated S2 RasterStack to disk   ###
##################################################################

writeRaster(S2stackDiff, "./output/raster/Sentinel-2/S2_diff_2019-18.grd", overwrite=TRUE)




################################################################################
###   read PS raster data of study area from 2018 and 2019 as RasterStacks   ###
################################################################################

PSstack20180419_20 <- stack("./output/raster/PlanetScope/PS_20180419_20.grd")
PSstack20190420_21 <- stack("./output/raster/PlanetScope/PS_20190420_21.grd")


####################################################################
###   subtract PS RasterStack of 2018 from RasterStack of 2019   ###
####################################################################

PSstackDiff <- PSstack20190420_21 - PSstack20180419_20


###################################################################
###   name layers of temporally differentiated PS RasterStack   ###
###################################################################

names(PSstackDiff)[1] <- "BLUE"
names(PSstackDiff)[2] <- "GREEN"
names(PSstackDiff)[3] <- "RED"
names(PSstackDiff)[4] <- "NIR"
names(PSstackDiff)[5] <- "NDVI"
names(PSstackDiff)[6] <- "GNDVI"
names(PSstackDiff)[7] <- "EVI"
names(PSstackDiff)[8] <- "CGM"
names(PSstackDiff)[9] <- "CVI"


##################################################################
###   write temporally differentiated PS RasterStack to disk   ###
##################################################################

writeRaster(PSstackDiff, "./output/raster/PlanetScope/PS_diff_2019-18.grd", overwrite=TRUE)