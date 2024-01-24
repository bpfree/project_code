# parameter setting

## designate date
date <- format(Sys.Date(), "%Y%m%d")

## region
region <- "region"

## setback
setback <- 500

## coordinate reference system
crs <- "EPSG:4326"

## calculate time
start_time <- Sys.time()
script_time <- Sys.time() - start_time

### print time difference
print(Sys.time() - start)
print(paste("Iteration", i, "of", length(vector), "takes", Sys.time() - start_time, units(Sys.time() - start_time), "to complete creating and adding", data_name, "data to dataframe", sep = " "))