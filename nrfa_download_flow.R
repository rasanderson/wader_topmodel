#!/usr/bin/env Rscript
# Get the information for a single station

library(rnrfa)
args <- commandArgs(trailingOnly = TRUE)
nrfa_station_id <- args[1]
start_date      <- args[2]
end_date        <- args[3]
out_file        <- args[4]
flowdata <- gdf(id = nrfa_station_id)
flowdata <- window(flowdata, start=as.Date(start_date))
write.table(flowdata, out_file, row.names=FALSE, col.names=FALSE)
