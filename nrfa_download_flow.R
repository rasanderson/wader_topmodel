# Get the information for a single station

library(rnrfa)
flowdata <- gdf(id = "21007")
flowdata <- window(flowdata, start=as.Date("2010-01-01"))
write.table(flowdata, "obs.txt", row.names=FALSE, col.names=FALSE)
