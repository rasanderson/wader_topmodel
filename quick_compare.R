topmod_pred <- read.table("topmod_output_for_R.txt", header=TRUE)
topmod_obs  <- read.table("obs_for_R.txt", col.names="nrfa_obs")

# Need to correct to same length as NRFA sometimes end mid-year
topmod_pred <- topmod_pred[1:nrow(topmod_obs),]
topmod <- cbind(topmod_pred, topmod_obs)

plot(topmod$Qt, topmod$nrfa_obs)

par(mfrow=c(2,1))
plot(1:3560, topmod$Qt, type="l")
plot(1:3560, topmod$nrfa_obs, type="l")
par(mfrow=c(1,1))
