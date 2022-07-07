# Get the information for a single station

library(nrfa)
flowdata <- gdf(id = "21007")
write.table(flowdata, "nrfa_21007.txt", row.names=FALSE, col.names=FALSE)
