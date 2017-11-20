#-------------------------------------------------------------------------------
# Name:        Bounding Box Creator
# Purpose:     Creates individual bounding box for all rasters within a
#              geodatabase.
#
# Author:      MMoore
#
# Created:     2017-11-17

#-------------------------------------------------------------------------------

# import packages
import os
import arcpy
from arcpy.sa import *

# set input and output geodatabases
input_gdb = r'C:\Users\mmoore\Documents\ArcGIS\test.gdb' # gdb where SDM rasters exist
output_gdb = r'C:\Users\mmoore\Documents\ArcGIS\test1.gdb' # gdb where bounding box features are saved

# set environment settings
arcpy.env.workspace = input_gdb
arcpy.env.overwriteOutput = True

# create list of rasters within input geodatabase
sdm_rasters = arcpy.ListRasters()

# begin loop through list of SDM rasters
for sdm in sdm_rasters:
    r = os.path.join(input_gdb, sdm)
    output = os.path.join(output_gdb, sdm)

    # create extent object for input raster
    r1 = arcpy.Raster(r)
    extent = r1.extent

    # create bounding box with extent of input raster
    arcpy.CreateFishnet_management(output,
    str(extent.XMin)+" "+str(extent.YMin),
    str(extent.XMin)+" "+str(extent.YMin+10), None, None, 1, 1,
    str(extent.XMax)+" "+str(extent.YMax), "NO_LABELS",
    str(extent.XMin)+" "+str(extent.YMin)+" "+str(extent.XMax)+" "+str(extent.YMax),
    "POLYGON")


