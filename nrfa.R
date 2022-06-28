# Setup NRFA
library(rnrfa)
library(sf)
library(dplyr)

# Output from g.region -p in wader
# GRASS wader/nras:wader_topmodel > g.region -p
# projection: 99 (OSGB 1936 / British National Grid)
# zone:       0
# datum:      osgb36
# ellipsoid:  airy
# north:      672193.00168603
# south:      568024.99948453
# west:       301325.00013442
# east:       435316.99780052
# nsres:      50.00864244
# ewres:      49.99701405
# rows:       2083
# cols:       2680
# cells:      5582440


## POLYGON
# Given as northwest, southwest, southeast, northeast, northwest (again)
# In each pair first is easting, second is northing
wader_list = list(rbind(c(301325.00013442, 672193.00168603),
                        c(301325.00013442, 568024.99948453),
                        c(435316.99780052, 568024.99948453),
                        c(435316.99780052, 672193.00168603),
                        c(301325.00013442, 672193.00168603)))
wader_osgb <- st_polygon(wader_list)
wader_osgb <- st_sfc(wader_osgb, crs = "EPSG:27700")
wader_osgb

wader_ll <- st_transform(wader_osgb, crs = "EPSG:4326")
ll_vals <-  as.vector(st_bbox(wader_ll))

wader_bbox <- list(lon_min = ll_vals[1], lon_max = ll_vals[3],
                   lat_min = ll_vals[2], lat_max = ll_vals[4])
wader_stations <- catalogue(wader_bbox)
wader_stations <- dplyr::filter(wader_stations,
                                opened <= "2010-01-01" &
                                  (closed >= "2020-12-31" | is.na(closed)))

# Display map and names of NRFA stations
library(ggmap)
library(ggrepel)
m <- get_map(location = ll_vals, maptype = 'terrain')
ggmap(m) +
  geom_point(data = wader_stations, aes(x = longitude, y = latitude),
                        col = "red", size = 3, alpha = 0.5) +
geom_text_repel(data = wader_stations, aes(x = longitude, y = latitude, label = name),
                    size = 3, col = "red")
  

# wader_stations is actually a nested list, with some columns data.frames
# these can be dropped before export
wader_stations2 <- dplyr::select(wader_stations, -c("grid-reference", "lat-long",
                                                    105, 106, 107))
wader_sf <- st_as_sf(x = wader_stations2, coords = c("easting", "northing"), crs = "EPSG:27700")

write_sf(wader_sf, "nrfa/nrfa_stations.gpkg")  
# In GRASS use v.import -o input=nrfa_stations.gpkg output=nrfa_stations
  
