#!/usr/bin/env Rscript
# Plot the sensitivty from the 10,000 random simulations

source("../scripts/run_rtopmodel.R")

obj_random <- read.table("sim_random/obj.txt")[[1]]
x_random <- read.table("sim_random/x.txt")

old.par <- par(mfrow=c(2,5), mar=c(4.1, 4.1, 1.1, 1.1))
for(i in 1:10) plot(x_random[,i], obj_random, ylim=c(0,0.5), xlab=par.name[i], pch=20)
