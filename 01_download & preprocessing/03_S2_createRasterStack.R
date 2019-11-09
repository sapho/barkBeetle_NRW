######################################################################
###   set variables for date and for directories with input data   ###
######################################################################

## date <- "20180420"
## dir_10m <- "./input/raster/Sentinel-2/unzipped/S2B_MSIL2A_20180420T103019_N0207_R108_T32UMB_20180420T114307.SAFE/GRANULE/L2A_T32UMB_A005854_20180420T103302/IMG_DATA/R10m/T32UMB_20180420T103019_"
## dir_20m <- "./input/raster/Sentinel-2/unzipped/S2B_MSIL2A_20180420T103019_N0207_R108_T32UMB_20180420T114307.SAFE/GRANULE/L2A_T32UMB_A005854_20180420T103302/IMG_DATA/R20m/T32UMB_20180420T103019_"

## date <- "20190420"
## dir_10m <- "./input/raster/Sentinel-2/unzipped/S2A_MSIL2A_20190420T103031_N0211_R108_T32UMB_20190420T111631.SAFE/GRANULE/L2A_T32UMB_A019982_20190420T103459/IMG_DATA/R10m/T32UMB_20190420T103031_"
## dir_20m <- "./input/raster/Sentinel-2/unzipped/S2A_MSIL2A_20190420T103031_N0211_R108_T32UMB_20190420T111631.SAFE/GRANULE/L2A_T32UMB_A019982_20190420T103459/IMG_DATA/R20m/T32UMB_20190420T103031_"

## date <- "20190724"
## dir_10m <- "./input/raster/Sentinel-2/unzipped/S2B_MSIL2A_20190724T103029_N0213_R108_T32UMB_20190724T130550.SAFE/GRANULE/L2A_T32UMB_A012432_20190724T103030/IMG_DATA/R10m/T32UMB_20190724T103029_"
## dir_20m <- "./input/raster/Sentinel-2/unzipped/S2B_MSIL2A_20190724T103029_N0213_R108_T32UMB_20190724T130550.SAFE/GRANULE/L2A_T32UMB_A012432_20190724T103030/IMG_DATA/R20m/T32UMB_20190724T103029_"


################################
###   set suffix variables   ###
################################

band02 <- "B02_10m.jp2"
band03 <- "B03_10m.jp2"
band04 <- "B04_10m.jp2"
band05 <- "B05_20m.jp2"
band06 <- "B06_20m.jp2"
band07 <- "B07_20m.jp2"
band08 <- "B08_10m.jp2"
band8A <- "B8A_20m.jp2"
band11 <- "B11_20m.jp2"
band12 <- "B12_20m.jp2"


###########################################
###   read bounding box of study area   ###
###########################################

bb <- shapefile("./output/vector/ShapeFile/BoundingBox_SWKKSL.shp")


########################################################################################
###   read 20m band layers, crop them to bounding box and disaggregate them to 10m   ###
########################################################################################

VEG_RE_1 <- disaggregate(crop(raster(paste(dir_20m, band05, sep="")), bb), 2)
names(VEG_RE_1) <- "VEG_RE_1"

VEG_RE_2 <- disaggregate(crop(raster(paste(dir_20m, band06, sep="")), bb), 2)
names(VEG_RE_2) <- "VEG_RE_2"

VEG_RE_3 <- disaggregate(crop(raster(paste(dir_20m, band07, sep="")), bb), 2)
names(VEG_RE_3) <- "VEG_RE_3"

NARROW_NIR <- disaggregate(crop(raster(paste(dir_20m, band8A, sep="")), bb), 2)
names(NARROW_NIR) <- "NARROW_NIR"

SWIR_1 <- disaggregate(crop(raster(paste(dir_20m, band11, sep="")), bb), 2)
names(SWIR_1) <- "SWIR_1"

SWIR_2 <- disaggregate(crop(raster(paste(dir_20m, band12, sep="")), bb), 2)
names(SWIR_2) <- "SWIR_2"


##############################################################
###   read 10m band layers and crop them to bounding box   ###
##############################################################

BLUE <- crop(raster(paste(dir_10m, band02, sep="")), VEG_RE_1)
names(BLUE) <- "BLUE"

GREEN <- crop(raster(paste(dir_10m, band03, sep="")), VEG_RE_1)
names(GREEN) <- "GREEN"

RED <- crop(raster(paste(dir_10m, band04, sep="")), VEG_RE_1)
names(RED) <- "RED"

NIR <- crop(raster(paste(dir_10m, band08, sep="")), VEG_RE_1)
names(NIR) <- "NIR"


##################################
###   calculate index layers   ###
##################################

NDVI <- (NIR-RED)/(NIR+RED)
names(NDVI) <- "NDVI"

GNDVI <- (NIR-GREEN)/(NIR+GREEN)
names(GNDVI) <- "GNDVI"

CGM <- (NIR/GREEN) - 1
names(CGM) <- "CGM"

EVI <- 2.5*(NIR-RED)/(NIR+6*RED-7.5*BLUE+1)
names(EVI) <- "EVI"

DWSI <- (NIR+GREEN)/(SWIR_1+RED)
names(DWSI) <- "DWSI"

NDRE1 <- (NIR-VEG_RE_1)/(NIR+VEG_RE_1)
names(NDRE1) <- "NDRE1"

NDRE2 <- (NIR-VEG_RE_2)/(NIR+VEG_RE_2)
names(NDRE2) <- "NDRE2"

CIRE <- (NIR/VEG_RE_1) - 1
names(CIRE) <- "CIRE"

CVI <- (NIR*RED/GREEN^2)
names(CVI) <- "CVI"


#################################################################################
###   stack band and index layers to RasterStack; write RasterStack to disk   ###
#################################################################################

S2stack <- stack(BLUE, GREEN, RED, VEG_RE_1, VEG_RE_2, VEG_RE_3, NIR, NARROW_NIR, SWIR_1, SWIR_2, NDVI, GNDVI, EVI, CGM, CVI, CIRE, NDRE1, NDRE2, DWSI)

if (date==20190724) {
  writeRaster(S2stack, paste("./output/raster/Sentinel-2/S2_",date,"_19predictors-10m.grd", sep=""), overwrite=TRUE)
} else {
  writeRaster(S2stack, paste("./output/raster/Sentinel-2/S2_",date,".grd", sep=""), overwrite=TRUE)
}