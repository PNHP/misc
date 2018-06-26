#---------------------------------------------------------------------------------------------
# Name: gbif_getter.r
# Purpose: 
# Author: Christopher Tracey
# Created: 2018-06-25
# Updated: 
#---------------------------------------------------------------------------------------------
tool_exec<- function(in_params, out_params){

if (!requireNamespace("sp", quietly=TRUE)) install.packages("sp")
require(sp)
if (!requireNamespace("rgdal", quietly=TRUE)) install.packages("rgdal")
require(rgdal)
if (!requireNamespace("arcgisbinding", quietly=TRUE)) install.packages("arcgisbinding")
require(arcgisbinding)
if (!requireNamespace("rgeos", quietly=TRUE)) install.packages("rgeos")
require(rgeos)
if (!requireNamespace("rgbif", quietly=TRUE)) install.packages("rgbif")
require(rgbif)
if (!requireNamespace("spocc", quietly=TRUE)) install.packages("spocc")
require(spocc)

  #arc.check_product()

### Define input/output parameters ########################################################################################
input_data <- in_params[[1]]
max_records <- in_params[[2]]
# input_data  <- paste(loc_scripts,"test_shape1.shp",sep="/")
# max_records <- 100
output_gbif <- out_params[[1]]
# output_gbif <- "TEST123"

loc_scripts <- "E:/communities/misc"
setwd(loc_scripts)

aoi <- arc.open(input_data)
aoi <- arc.select(aoi)
aoi <- arc.data2sp(aoi)
prj <- CRS("+proj=longlat +datum=WGS84")
aoi2 <- spTransform(aoi, prj)

aoi_wkt <- writeWKT(aoi2)

dat <- occ_search(
  #taxonKey=keys, 
  limit=max_records,
  return='data', 
  hasCoordinate=TRUE,
  geometry=aoi_wkt,
  geom_big="bbox",
  #year=time_period,
  fields=c('name','scientificName','datasetKey','recordedBy','key','decimalLatitude','decimalLongitude','country','basisOfRecord','coordinateAccuracy','year','month','day','coordinateUncertaintyInMeters')
)
pts <- as.data.frame(dat[,c("decimalLongitude","decimalLatitude")])
gbif_pts <- SpatialPointsDataFrame(coords=pts,data=dat,proj4string=prj)
###arc.write(paste(loc_scripts,"/pts_gbif.shp",sep=""),gbif_pts)

if(!is.null(output_gbif) && output_gbif != "NA")
  arc.write(output_gbif,gbif_pts) # , shape_info = arc.shapeinfo(d)  #paste("E:/communities/misc/gbif_getter.gdb/",,sep=""

return(out_params)

}
