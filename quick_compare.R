# Allows quick visual comparison of observations and predictions
library(lubridate)
library(ggplot2)
library(tidyr)
library(dplyr)

subcatch_no <- 26
nrfa_no     <- 21012

preds <- read.table(paste0("subcatch_dat/output.txt.", subcatch_no),
                    skip=66, header=TRUE)
nrfa  <- read.table(paste0("subcatch_dat/obs.txt.", nrfa_no))

date  <- seq(ymd('2010-01-01'),ymd('2017-12-31'),by='days')

topmod <- cbind(preds, nrfa, date)
colnames(topmod)[10] <- "nrfa"
par(mar=c(5,4.5,4,2) + 0.1)
plot(1:nrow(topmod), topmod$nrfa, type="l", xlab="Time (days)",
     ylab=expression(Steramflow~m^2/day))
lines(topmod$Qt, col="red")
plot(1:1600, topmod$nrfa[1:1600], type="l", xlab="Time (days)",
     ylab=expression(Steramflow~m^2/day))
lines(topmod$Qt[1:1600], col="red")
legend("topleft", c("Observed", "Predicted"), col=c("black", "red"), lty=c(1, 1), bty="o")
par(mar=c(5, 4, 4, 2) + 0.1) # defaults

topmod_lng <- pivot_longer(topmod, !date, names_to="topmod_output",
                           values_to="output")
topmod_lng %>%
   filter(topmod_output == "Qt" | topmod_output == "nrfa") %>%
ggplot(aes(x = date, y=output, colour=topmod_output)) +
   geom_line() +
	 theme_classic()
