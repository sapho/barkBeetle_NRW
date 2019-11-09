######################################################################
###   read bounding box of study area as SpatialPolygons feature   ###
######################################################################

swkksl <- shapefile("./output/vector/ShapeFile/BoundingBox_SWKKSL.shp")
xym <- (swkksl[0]@polygons[[1]]@Polygons[[1]]@coords)

p <- Polygon(xym)
ps <- Polygons(list(p),1)
aoi <- SpatialPolygons(list(ps))

proj4string(aoi) <- CRS("+init=epsg:25832")


##################################################
###   Set the SpatialPolygons feature as AOI   ###
##################################################

set_aoi(aoi)

time_range <-  c("2019-07-01", "2019-07-31")
platform <- "Sentinel-2"


#################################
###   Set login credentials   ###
#################################

login_CopHub(username = "your username", password = "your password")


###############################################################
###   use getSentinel_query to search for data within AOI   ###
###############################################################

records <- getSentinel_query(time_range = time_range, platform = platform)


##############################
###   filter the records   ###
##############################

records_filtered <- records[which(records$processinglevel == "Level-2A"),]
records_filtered <- records_filtered[as.numeric(records_filtered$cloudcoverpercentage) < 1, ]


##########################################################
###   download queried datasets to archive directory   ###
##########################################################

dir.create("./input/raster/Sentinel-2/zipped", recursive = TRUE)
set_archive("./input/raster/Sentinel-2/zipped")

datasets <- getSentinel_data(records = records_filtered)


##########################################################
###   extract downloaded datasets to unzip directory   ###
##########################################################

dir.create("./input/raster/Sentinel-2/unzipped")
for (i in 0:(length(datasets)-1)) {
  i <- i+1
  unzip (datasets[i], exdir = "./input/raster/Sentinel-2/unzipped")
}
remove(i)