# Get the information for a single station

library(nrfa)
flowdata <- gdf(id = "21007")
write.table(flowdata, "obs.txt", row.names=FALSE, col.names=FALSE)
