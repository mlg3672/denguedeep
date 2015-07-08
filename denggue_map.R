library(sp)  # classes for spatial data
library(raster)  # grids, rasters
library(rasterVis)  # raster visualisation
library(maptools)
library(rgeos) # and their dependencies

# --generate a generic map
library(dismo)
mymap <- gmap("Malaysia")  # choose whatever country
plot(mymap)

# --generate satalite map
mymap <- gmap("Malaysia", type = "satellite")
plot(mymap)

# -- map data onto google map tiles
library(RgoogleMaps)
newmap <- GetMap(center = c(36.7, -5.9), zoom = 10, destfile = "newmap.png", 
                 maptype = "satellite")

# Now using bounding box instead of center coordinates:
newmap2 <- GetMap.bbox(lonR = c(-5, -6), latR = c(36, 37), destfile = "newmap2.png", 
                       maptype = "terrain")

# Try different maptypes
newmap3 <- GetMap.bbox(lonR = c(-5, -6), latR = c(36, 37), destfile = "newmap3.png", 
                       maptype = "satellite")
# plot data points onto map --failed
PlotOnStaticMap(lat = c(36.3, 35.8, 36.4), lon = c(-5.5, -5.6, -5.8), zoom = 10, 
                cex = 4, pch = 19, col = "red", FUN = points, add = F, 
                MaxZoom(latrange=c(36,37),lonrange = c(-5.2,-6.0),size = c(640,640)))

# --- visualize data in a web browser using google api
library(googleVis)
# plot country level data
data(Exports)    # a simple data frame
Geo <- gvisGeoMap(Exports, locationvar="Country", numvar="Profit", 
                  options=list(height=400, dataMode='regions'))
plot(Geo)
print(Geo) # get html code to embed in webpage

# -- plot point hurricane data in interactive google map

data(Andrew)
M1 <- gvisMap(Andrew, "LatLong", "Tip", 
              options=list(showTip=TRUE, showLine=F, enableScrollWheel=TRUE, 
                           mapType='satellite', useMapTypeControl=TRUE, width=800,height=400))
plot(M1)

# using raster grid data to download climate data using dismo package
tmin <- getData("worldclim", var = "tmin", res = 10)  # this will download 
# global data on minimum temperature at 10' resolution
tmin1 <- raster(paste(getwd(), "/wc10/tmin1.bil", sep = ""))  # Tmin for January
tmin1 <- tmin1/10  # Worldclim temperature data come in decimal degrees 
tmin1  # look at the info
plot(tmin1)