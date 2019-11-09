########################################################################
###   set variables for date and for list of files with input data   ###
########################################################################

## date <- "20180419_20"
## PSfiles <- list.files("./input/raster/PlanetScope/2018/04", pattern="SR.tif$", full.names=TRUE, recursive=TRUE)

## date <- "20190420_21"
## PSfiles <- list.files("./input/raster/PlanetScope/2019/04", pattern="SR.tif$", full.names=TRUE, recursive=TRUE)

## date <- "20190724"
## PSfiles <- list.files("./input/raster/PlanetScope/2019/07", pattern="SR.tif$", full.names=TRUE, recursive=TRUE)


#####################################################################################################
###   apply incremental histogram matching to stacked input files and mosaic them to RasterBrick  ###
#####################################################################################################

for (i in 1:length(PSfiles)) {
  if (!exists("rb")) {
    rb <- mosaic(histMatch(stack(PSfiles[i]), stack(PSfiles[i+1])), stack(PSfiles[i+1]), fun=mean)
    ## variant for stacking and mosaicing input files without incremental histogram matching (for test purposes only):
    ## rb <- mosaic(stack(PSfiles[i]), stack(PSfiles[i+1]), fun=mean)
    i <- i+1
  } else {
    rb <- mosaic(histMatch(rb, stack(PSfiles[i])), stack(PSfiles[i]), fun=mean)
    ## variant for stacking and mosaicing input files without incremental histogram matching (for test purposes only):
    ## rb <- mosaic(rb, stack(PSfiles[i]), fun=mean)
  }
}
rm(i)

plot(rb)


#####################################################################
###   read bounding box of study area and crop RasterBrick to it  ###
#####################################################################

bb <- shapefile("./output/vector/ShapeFile/BoundingBox_SWKKSL.shp")
rb <- crop(rb, bb)

plot(rb)


#####################################
###   write RasterBrick to disk   ###
#####################################

writeRaster(rb, paste("./output/raster/PlanetScope/PS_brick_",date,".grd", sep=""), overwrite=TRUE)

rm(rb)