# Plot the progress of the calibration and final results

repeat{
    #obj <- read.table("sim/obj.txt")[[1]]; plot(cummin(obj), ylim=c(0, 0.5), type="l")
    obj <- read.table("sim/obj.txt")[[1]]; plot(cummin(obj), type="l")
    cat(sprintf("obj=%f, NSE=%f\n", min(obj), 1-min(obj)))
    Sys.sleep(1)
}
