#---------------------------------------------------------------------------------------------
# Name: gbif_getter.r
# Purpose: 
# Author: Christopher Tracey
# Created: 2018-06-25
# Updated: 
#---------------------------------------------------------------------------------------------
tool_exec<- function(in_params, out_params){

if (!requireNamespace("rgbif", quietly=TRUE)) install.packages("rgbif")
require(rgbif)
if (!requireNamespace("sp", quietly=TRUE)) install.packages("sp")
require(sp)
if (!requireNamespace("rgdal", quietly=TRUE)) install.packages("rgdal")
require(rgdal)
if (!requireNamespace("arcgisbinding", quietly=TRUE)) install.packages("arcgisbinding")
require(arcgisbinding)
if (!requireNamespace("rgeos", quietly=TRUE)) install.packages("rgeos")
require(rgeos)

#arc.check_product()

### Define input/output parameters ########################################################################################
input_data <- in_params[[1]]
# input_data  <- paste(loc_scripts,"test_shape.shp",sep="/")
output_gbif <- out_params[[1]]

loc_scripts <- "E:/communities/misc"
setwd(loc_scripts)

aoi <- arc.open(input_data )
aoi <- arc.select(aoi)
aoi <- arc.data2sp(aoi)

prj <- CRS("+proj=longlat +datum=WGS84")
aoi2 <- spTransform(aoi, prj)

aoi_wkt <- writeWKT(aoi2)

dat <- occ_search(
  #taxonKey=keys, 
  limit=100,
  return='data', 
  hasCoordinate=TRUE,
  geometry=aoi_wkt, 
  #year=time_period,
  fields=c('name','scientificName','datasetKey','recordedBy','key','decimalLatitude','decimalLongitude','country','basisOfRecord','coordinateAccuracy','year','month','day','coordinateUncertaintyInMeters')
)
pts <- as.data.frame(dat[,c("decimalLongitude","decimalLatitude")])
gbif_pts <- SpatialPointsDataFrame(coords=pts,data=dat,proj4string=prj)
###arc.write(paste(loc_scripts,"/pts_gbif.shp",sep=""),gbif_pts)

if(!is.null(output_gbif) && output_gbif != "NA")
  arc.write(paste(loc_scripts,"/pts_gbif.shp",sep=""),gbif_pts) # , shape_info = arc.shapeinfo(d)


}
