# File: EnvVarExtractor.r
# Purpose: attribute environmental data to veg plot points

## start with a fresh workspace with no objects loaded
library(raster)
library(rgdal)
library(RSQLite)
library(maptools)

# load data, QC ----
setwd("E:/communities/geotiffs")

# create a stack
# if using TIFFs, use this line
raslist <- list.files(pattern = ".tif$")
gridlist <- as.list(raslist)
nm <- substr(raslist,1,nchar(raslist) - 4)
names(gridlist) <- nm
# check to make sure there are no names greater than 10 chars
nmLen <- unlist(lapply(nm, nchar))
max(nmLen) # if this result is greater than 10, you've got a renegade

envStack <- stack(gridlist)

# Set working directory to the random points location
setwd("E:/communities")
ranPtsFiles <- list.files(pattern = ".shp$")
ranPtsFiles
#look at the output and choose which shapefile you want to run
#enter its location in the list (first = 1, second = 2, etc)
n <- 1
ranPtsFilesNoExt <- sub(".shp","",ranPtsFiles[n])
shpf <- readOGR(".", layer = ranPtsFilesNoExt)

#get projection info for later
projInfo <- shpf@proj4string

# extract raster data to points ----
##  Bilinear interpolation is a *huge* memory hog. 
##  Do it all as 'simple' 
points_attributed <- extract(envStack, shpf, method="simple", sp=TRUE)

# write it out ----
# apply projection info
points_attributed@proj4string <- projInfo
filename <- paste(ranPtsFilesNoExt, "_att", sep="")
writeOGR(points_attributed, ".", layer=paste(filename), driver="ESRI Shapefile", overwrite_layer=TRUE)
