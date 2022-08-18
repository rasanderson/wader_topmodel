# Allows quick visual comparison of observations and predictions
library(lubridate)
library(ggplot2)
library(tidyr)

subcatch_no <- 3
nrfa_no     <- 21027

preds <- read.table(paste0("subcatch_dat/output.txt.", subcatch_no),
                    skip=66, header=TRUE)
nrfa  <- read.table(paste0("subcatch_dat/obs.txt.", nrfa_no))

date  <- seq(ymd('2010-01-01'),ymd('2017-12-31'),by='days')

topmod <- cbind(preds, nrfa, date)
colnames(topmod)[10] <- "nrfa"
plot(1:nrow(topmod), topmod$Qt, type="l")
lines(topmod$nrfa, col="red")

topmod_lng <- pivot_longer(topmod, !date, names_to="topmod_output",
                           values_to="output")
topmod_lng %>%
   filter(topmod_output == "Qt" | topmod_output == "nrfa") %>%
ggplot(aes(x = date, y=output, colour=topmod_output)) +
   geom_line() +
	 theme_classic()
