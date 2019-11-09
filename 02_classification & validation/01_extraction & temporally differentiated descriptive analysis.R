##############################################################################################################
###   read temporally differentiated, specifically preprocessed RasterStack of study area's bounding box   ###
##############################################################################################################

## rs <- stack("./output/raster/Sentinel-2/S2_diff_2019-18.grd")

## rs <- stack("./output/raster/PlanetScope/PS_diff_2019-18.grd")


###################################################################################
###   detect satellite source of raster stack for setting auxiliary variables   ###
###################################################################################

if (res(rs)[1]==3) {
        sat <- "PlanetScope"
        indices <- 5
} else if (res(rs)[1]==10) {
        sat <- "Sentinel-2"
        indices <- 9
}


#############################################################
###   read reference data and add column for feature id   ###
#############################################################

refData <- read_sf("./input/vector/ShapeFile/reference_data_20190420.shp", fid_column_name="id")
refData <- st_transform(refData, "+init=epsg:32632")


#############################################################################
###   extract band and index values for reference data from RasterStack   ###
#############################################################################

extr <- extract(rs, refData, df=TRUE)


#######################################################
###   define color scheme for plotting of classes   ###
#######################################################

mycolor <- c("red", "green")


##################################################################################################################################################
###   create matrix with mean values of extracted band and index values for temporally differentiated spectral profiles and index signatures   ###
##################################################################################################################################################

ms <- matrix(NA, nrow=length(unique(refData$status)), ncol=nlayers(rs))
rownames(ms) <- unique(refData$status)
colnames(ms) <- names(extr[(which(names(extr[])=="ID")+1):length(extr)])

for (i in unique(refData$status)){
        x <- extr[refData$status==i,c((which(names(extr[])=="ID")+1):length(extr))]
        ms[i,] <- colMeans(x)
}
rm(i)


#######################################################################
###   plot temporally differentiated spectral profiles of classes   ###
#######################################################################

plot("NA", ylim=c(min(ms[1:((length(ms[1,])-indices)*2)]), max(ms[1:((length(ms[1,])-indices)*2)])), xlim=c(1,length(ms[1,])-indices), xlab="Bands", ylab="Difference in Reflectance between 2018-04-20 and 2019-04-20", xaxt="n")
axis(1, at=1:length(ms[1,]), lab=colnames(ms))

for (i in 1:nrow(ms)){
        lines(ms[i,1:(length(ms[1,])-indices)], type="o", lwd=3, lty=1, col=mycolor[i])
}
rm(i)

title(main=paste("Temporally differentiated spectral Profile from",sat), font.main=2, cex.main=1.7)
legend("topleft", rownames(ms), cex=0.8, col=mycolor, lty=1, lwd=3, bty="n")


##########################################################################################################
###   determine and print temporally differentiated band with highest difference between the classes   ###
##########################################################################################################

maxBandDiff <- names(ms[1,])[which(abs(diff(ms[]))==max(abs(diff(ms[,1:(length(ms[1,])-indices)]))))]
print(maxBandDiff)
ms[1:2,which(abs(diff(ms[]))==max(abs(diff(ms[,1:(length(ms[1,])-indices)]))))]
max(abs(diff(ms[,1:(length(ms[1,])-indices)])))


######################################################################
###   plot temporally differentiated index signatures of classes   ###
######################################################################

plot(1, ylim=c(min(ms[((length(ms[1,])-indices)*2+1):(length(ms[1,])*2)]), max(ms[((length(ms[1,])-indices)*2+1):(length(ms[1,])*2)])), xlim=c(length(ms[1,])-indices+1,length(ms[1,])), xlab="Indices", ylab="Difference between 2018-04-20 and 2019-04-20", xaxt="n")
axis(1, at=1:length(ms[1,]), lab=colnames(ms))

for (i in 1:nrow(ms)){
        lines(ms[i,1:length(ms[1,])], type="o", lwd=5, lty=0, col=mycolor[i])
}
rm(i)

title(main=paste("Temporally differentiated Index Signature from",sat), font.main=2, cex.main=1.7)
legend("topleft", rownames(ms), cex=0.8, col=mycolor, lty=1, lwd=3, bty="n")


###########################################################################################################
###   determine and print temporally differentiated index with highest difference between the classes   ###
###########################################################################################################

maxIndexDiff <- names(ms[1,])[which(abs(diff(ms[]))==max(abs(diff(ms[,(length(ms[1,])-indices+1):length(ms[1,])]))))]
print(maxIndexDiff)
ms[1:2,which(abs(diff(ms[]))==max(abs(diff(ms[,(length(ms[1,])-indices+1):length(ms[1,])]))))]
max(abs(diff(ms[,(length(ms[1,])-indices+1):length(ms[1,])])))


########################################################################################################################
###   merge extracted band and index values of reference data with geometry and status attribute of reference data   ###
########################################################################################################################

extr <- merge(extr, refData, by.x="ID", by.y="id")


###########################################################################
###   create temporally differentiated box plots of bands and indices   ###
###########################################################################

boxplot(extr$RED~extr$status, 
        main=paste("Change over time in RED (",sat,")", sep=""),
        names=c("infested spruce","not infested spruce"),
        xlab="", ylab="Difference between 2018-04-20 and 2019-04-20",
        cex.main=2.5, cex.lab=2.0, cex.axis=2.0,
        par(mar=c(5,5,4,1)+0.1),
        col=mycolor, 
        outline=FALSE)

boxplot(extr$NDVI~extr$status, 
        main=paste("Change over time in NDVI (",sat,")", sep=""),
        names=c("infested spruce","not infested spruce"),
        xlab="", ylab="Difference between 2018-04-20 and 2019-04-20",
        cex.main=2.5, cex.lab=2.0, cex.axis=2.0,
        par(mar=c(5,5,4,1)+0.1),
        col=mycolor, 
        outline=FALSE)

boxplot(extr$NIR~extr$status, 
        main=paste("Change over time in NIR (",sat,")", sep=""),
        names=c("infested spruce","not infested spruce"),
        xlab="", ylab="Difference between 2018-04-20 and 2019-04-20",
        cex.main=2.5, cex.lab=2.0, cex.axis=2.0,
        par(mar=c(5,5,4,1)+0.1),
        col=mycolor, 
        outline=FALSE)