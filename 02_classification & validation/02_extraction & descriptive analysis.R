######################################################################################################################
###   read specifically preprocessed data of study area's bounding box as RasterStack and set auxiliary variables  ###
######################################################################################################################

## rs <- stack("./output/raster/Sentinel-2/S2_20190724_19predictors-10m.grd")
## sat <- "Sentinel-2"
## modelVariant <- "S2_19predictors-10m"
## indices <- 9

## rs <- stack("./output/raster/PlanetScope/PS_20190724_9predictors-3m.grd")
## sat <- "PlanetScope"
## modelVariant <- "PS_9predictors-3m"
## indices <- 5

## rs <- stack("./output/raster/Sentinel-2/S2_20190724_9predictors-10m.grd")
## sat <- "Sentinel-2"
## modelVariant <- "S2_9predictors-10m"
## indices <- 5

## rs <- stack("./output/raster/PlanetScope/PS_20190724_9predictors-10m.grd")
## sat <- "PlanetScope"
## modelVariant <- "PS_9predictors-10m"
## indices <- 5


#############################################################
###   read reference data and add column for feature id   ###
#############################################################

refData <- read_sf("./input/vector/ShapeFile/reference_data_20190724.shp", fid_column_name="id")
refData <- st_transform(refData, "+init=epsg:32632")


##############################################################################
###   extract band and index values for reference data from raster stack   ###
##############################################################################

extr <- extract(rs, refData, df=TRUE)


#######################################################
###   define color scheme for plotting of classes   ###
#######################################################

mycolor <- c("red", "green")


########################################################################################################################
###   create matrix with mean values of extracted band and index values for spectral profiles and index signatures   ###
########################################################################################################################

ms <- matrix(NA, nrow=length(unique(refData$status)), ncol=nlayers(rs))
rownames(ms) <- unique(refData$status)
colnames(ms) <- names(extr[(which(names(extr[])=="ID")+1):length(extr)])

for (i in unique(refData$status)){
  x <- extr[refData$status==i,c((which(names(extr[])=="ID")+1):length(extr))]
  ms[i,] <- colMeans(x)
}
rm(i)


#############################################
###   plot spectral profiles of classes   ###
#############################################

plot("NA", ylim=c(min(ms[1:((length(ms[1,])-indices)*2)]), max(ms[1:((length(ms[1,])-indices)*2)])), xlim=c(1,length(ms[1,])-indices), xlab="Bands", ylab="Reflectance", xaxt="n")
axis(1, at=1:length(ms[1,]), lab=colnames(ms))

for (i in 1:nrow(ms)){
  lines(ms[i,1:(length(ms[1,])-indices)], type="o", lwd=3, lty=1, col=mycolor[i])
}
rm(i)

title(main=paste("Spectral Profile on 2019-07-24  (",sat,")", sep=""),font.main=2, cex.main=1.7)
legend("topleft", rownames(ms), cex=0.8, col=mycolor, lty=1, lwd=3, bty="n")


################################################################################
###   determine and print band with highest difference between the classes   ###
################################################################################

maxBandDiff <- names(ms[1,])[which(abs(diff(ms[]))==max(abs(diff(ms[,1:(length(ms[1,])-indices)]))))]
print(maxBandDiff)
ms[1:2,which(abs(diff(ms[]))==max(abs(diff(ms[,1:(length(ms[1,])-indices)]))))]
max(abs(diff(ms[,1:(length(ms[1,])-indices)])))


############################################
###   plot index signatures of classes   ###
############################################

plot(1, ylim=c(min(ms[((length(ms[1,])-indices)*2+1):(length(ms[1,])*2)]), max(ms[((length(ms[1,])-indices)*2+1):(length(ms[1,])*2)])), xlim=c(length(ms[1,])-indices+1,length(ms[1,])), xlab="Indices", ylab="Mean", xaxt='n')
axis(1, at=1:length(ms[1,]), lab=colnames(ms))

for (i in 1:nrow(ms)){
  lines(ms[i,1:length(ms[1,])], type="o", lwd=5, lty=0, col=mycolor[i])
}
rm(i)

title(main=paste("Index Signature on 2019-07-24  (",sat,")", sep=""),font.main=2, cex.main=1.7)
legend("topleft", rownames(ms), cex=0.8, col=mycolor, lty=1, lwd=3, bty="n")


#################################################################################
###   determine and print index with highest difference between the classes   ###
#################################################################################

maxIndexDiff <- names(ms[1,])[which(abs(diff(ms[]))==max(abs(diff(ms[,(length(ms[1,])-indices+1):length(ms[1,])]))))]
print(maxIndexDiff)
ms[1:2,which(abs(diff(ms[]))==max(abs(diff(ms[,(length(ms[1,])-indices+1):length(ms[1,])]))))]
max(abs(diff(ms[,(length(ms[1,])-indices+1):length(ms[1,])])))



########################################################################################################################
###   merge extracted band and index values of reference data with geometry and status attribute of reference data   ###
########################################################################################################################

extr <- merge(extr, refData, by.x="ID", by.y="id")



################################################################################
###   create box plots of band with highest difference between the classes   ###
################################################################################

boxplot(extr[,maxBandDiff]~extr$status, 
        main=paste("Difference in ",maxBandDiff," on 2019-07-24 (",sat,")", sep=""),
        names=c("infested spruce","not infested spruce"),
        xlab="", ylab="Reflectance",
        cex.main=1.6, cex.lab=1.6, cex.axis=1.6, cex.sub=1.6,
        col=c("red", "green"), 
        outline=FALSE)


#######################################################################################
###   create box plots of index with highest index difference between the classes   ###
#######################################################################################

boxplot(extr[,maxIndexDiff]~extr$status, 
        main=paste("Difference in ",maxIndexDiff," on 2019-07-24 (",sat,")", sep=""),
        names=c("infested spruce","not infested spruce"),
        xlab="", ylab="Reflectance",
        cex.main=1.6, cex.lab=1.6, cex.axis=1.6, cex.sub=1.6,
        col=c("red", "green"), 
        outline=FALSE)


#######################################################
###   create scatter plots of RED, NIR, NDVI, CGM   ###
#######################################################

featurePlot(x=extr[, c("RED", "NIR", "NDVI","CGM")],
            main=paste("Feature plot matrix of 2019-07-24 (",sat,")", sep=""),
            par.settings = list(superpose.symbol=list(pch=c(19,19), cex=c(0.5, 0.5), col=mycolor)),
            y=factor(extr$status),
            plot="pairs",
            auto.key=list(columns=4))


###########################################################################
###   create scatter plots of VEG_RE_1, NDRE1, SWIR_1, DWSI (S2 only)   ###
###########################################################################

featurePlot(x=extr[, c("VEG_RE_1", "NDRE1", "SWIR_1","DWSI")],
            main=paste("Feature plot matrix of 2019-07-24 (",sat,")", sep=""),
            par.settings = list(superpose.symbol=list(pch=c(19,19), cex=c(0.5, 0.5), col=mycolor)),
            y=factor(extr$status),
            plot="pairs",
            auto.key=list(columns = 4))