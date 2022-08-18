# Create a mean set of parameters as a 'template' based on
# those subcatchments ('edge' ones) where NRFA data used.
# This template can then be used for subcatchments at the edge
# where calibration is not possible due to lack of NRFA data.

# subcatchments where parameters available
available <- c(3, 4, 5, 7, 13, 17, 18, 21, 24, 26)

# There are 12 parameters in topmodel (plus subcatch area and subbasins)
# 61 rows read in
parval_rows <- c(14, 17, 20, 23, 26, 33, 36, 39, 43, 46, 49, 52)
parvals <- rep(0, 12)

for(in_file_no in 1:length(available)){
  param_raw <- readLines(paste0("subcatch_dat/params.txt.", available[in_file_no]))
  for(in_row in 1:61){
    for(parameter in 1:length(parval_rows)){
      if (in_row == parval_rows[parameter]){
				#cat(in_file_no, available[in_file_no], param_raw[in_row], "\n")
				parvals[parameter] <- parvals[parameter] + as.numeric(param_raw[in_row])
      }
    }
  }
}
# Convert to means
parvals <- parvals / length(available)

outfile   <- "topmod_params_mean_init.txt"

# To write info to file; write line 1 to force creation of new file
`%!in%` <- Negate(`%in%`)
#cat(param_raw[1], file=outfile, append=FALSE, "\n")
cat(param_raw[1], "\n")
for (line_out in 2:61){ # 61 as that is list up to 0.0 0.0 of subcatch
	for(parameter in 1:length(parval_rows)){
		if (line_out == parval_rows[parameter]){
			cat(parvals[parameter], "\n")
		}
	}
	if (line_out == 7){
    cat("SUBCATCH AREA", "\n")
	} else if (line_out %!in% parval_rows){
		cat(param_raw[line_out], "\n")
	}
}
  if(line_out == 7){
    cat("ENTER SUBCATCH AREA", file=outfile, append=TRUE, "\n")
  } else if(line_out == 14) {
    cat("Mean qs0 will go here", file=outfile, append=TRUE, "\n")
  } else {
    cat(param_raw[line_out], file=outfile, append=TRUE, "\n")
  }
}


