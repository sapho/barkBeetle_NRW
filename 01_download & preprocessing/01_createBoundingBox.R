####################################
###   read shape of study area   ###
####################################

bb_SWKKSL <-  shapefile("./input/vector/ShapeFile/SWKKSL.shp")


###############################################################################################
###   calculate extent of study area, set reference system and convert to spatial feature   ###
###############################################################################################

bb_SWKKSL <- extent(bb_SWKKSL)
bb_SWKKSL <- as(bb_SWKKSL, 'SpatialPolygons')
proj4string(bb_SWKKSL) <- CRS("+init=epsg:32632")
bb_SWKKSL <- as(bb_SWKKSL, 'sf')


################################################################
###   write ShapeFile of study area's bounding box to disk   ###
################################################################

st_write(bb_SWKKSL, "./output/vector/ShapeFile/BoundingBox_SWKKSL.shp", delete_layer=TRUE)