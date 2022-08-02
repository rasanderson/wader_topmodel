#!/usr/bin/env Rscript
# After doing a calibration and validation this allows you to check the
# value of the best NSE objective function and then plot topmodel
# results for calibration and validation data.

args <- commandArgs(trailingOnly = TRUE)
subcatch_no            <- args[1]
calibration_start_date <- args[2]
calibration_end_date   <- args[3]
validation_start_date  <- args[4]
validation_end_date    <- args[5]

source("config.R")
source("../scripts/run_rtopmodel.R")
source("../scripts/read_write_rtopmodel.R")

obj <- read.table("sim/obj.txt")[[1]]
x <- read.table("sim/x.txt")

best_idx <- which(obj==min(obj))
best_x <- as.numeric(x[best_idx,])

obs_c <- read.table("obs_c.txt")[[1]]
sim_c <- run_rtopmodel_x(best_x, path_c)
write.table(sim_c, "sim_c.txt", row.names=FALSE, col.names=FALSE)

nse <- calc_nse(obs_c, sim_c, skip_c)

# Inspect observed and predicted for calibration
par(mar=c(5, 4.5, 4, 2) + 0.1) # Tweak so superscript fits into y-axis label
plot(obs_c[-(1:skip_c)], type="l", xlab="Time (days)", ylab=expression(Streamflow~(m^3/day)),
  main=paste0("Subcatchment ",subcatch_no, " calibration"),
  sub=paste0(calibration_start_date, " to ", calibration_end_date))
lines(sim_c[-(1:skip_c)], col="red")
legend("topleft", c("Observed", "Predicted"), col=c("black", "red"), lty=c(1, 1), bty="o",
  title=paste0("NSE=",round(nse,3)))
par(mar=c(5, 4, 4, 2) + 0.1) # Defaults 

plot(obs_c, sim_c, main=paste0("Subcatchment ",subcatch_no, " calibration"),
  xlim = c(0, max(c(obs_c, sim_c))), ylim = c(0, max(c(obs_c, sim_c))), 
  xlab = "Observed", ylab = "Predicted")
abline(0, 1, col="red")

## My model seems to underpredict at high flows, but my best model seems to
## overestimate baseflows. The latter is similar to tutorial, which comments:
## We can see that the best model tends to overestimate baseflows. Overall,
## simulated hydrographs decline at a slower rate than observed ones. This
## behavior might be attributed to the use of the NSE as the objective function
## because the NSE puts more weights on peak flows. It might be the
## single-watershed configuration or the infiltration calculation in r.topmodel.
## Probably, it might be the structure of TOPMODEL itself that has failed to
## simulate baseflows. Let’s see if r.topmodel has completely failed to
## simulate baseflows by plotting all 1,000 simulations. In the Generalized
## Likelihood Uncertainty Estimation (GLUE) framework (Beven and Binley, 2014),
## these simulations from the same model structure are called “models.”
## Next is the code to display all 1000 simulations
#sim_c <- c()
#for(i in 1:1000){
#    file <- sprintf("sim/sim_c_%04d.txt", i)
#    sim_c <- rbind(sim_c, read.table(file)[[1]])
#}
#
#matplot(t(sim_c), type="l", col="green", lty=1, ylab=expression(Streamflow~(m^3/d)))
#lines(obs_c, col="red")
#legend("topleft", legend=c("obs_c", "sim_c"), col=c("red", "green"), lty=1, bty="n")
# My plot is similar to tutorial in that most of the observations are within
# the range of simulated models. Not sure this is best way of showing the
# results so might not use it. Comments from tutorial below:
# From the above plot, the observed streamflow is mostly within the
# simulated range. If we consider these “models” from the same model
# structure of TOPMODEL different models, constructing an ensemble model
# may be a good idea because no models are perfect and they all come with
# uncertainty.

# NSE for validation data 2015 to Sept 2019
obs_v <- read.table("obs_v.txt")[[1]]
sim_v <- run_rtopmodel(path_v)
write.table(sim_v, "sim_v.txt", row.names=FALSE, col.names=FALSE)

nse <- calc_nse(obs_v, sim_v, skip_v)

# Plot of observed vs simulations for validation
par(mar=c(5, 4.5, 4, 2) + 0.1) # Tweak so superscript fits into y-axis label
plot(obs_v[-(1:skip_v)], type="l", xlab="Time (days)", ylab=expression(Streamflow~(m^3/day)),
  main=paste0("Subcatchment ",subcatch_no, " validation"),
  sub=paste0(validation_start_date, " to ", validation_end_date))
lines(sim_v[-(1:skip_v)], col="red")
legend("topleft", c("Observed", "Predicted"), col=c("black", "red"), lty=c(1, 1),
       bty="o", bg="white", title=paste0("NSE=",round(nse,3)))
par(mar=c(5, 4, 4, 2) + 0.1) # Defaults 

plot(obs_v, sim_v, main=paste0("Subcatchment ",subcatch_no, " validation"), 
  xlim = c(0, max(c(obs_v, sim_v))), ylim = c(0, max(c(obs_v, sim_v))), 
  xlab = "Observed", ylab = "Predicted")
abline(0, 1, col="red")
