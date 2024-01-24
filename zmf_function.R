# z-shaped membership function

### Examples of this code
#### https://github.com/bpfree/westport_mussels_aoa/blob/35e4dc1c9e8c32bea06a034c54593ab6c0804daa/code/15_ais.R#L93
#### https://github.com/bpfree/westport_mussels_aoa/blob/35e4dc1c9e8c32bea06a034c54593ab6c0804daa/code/20_large_pelagic_survey.R#L96
#### https://github.com/bpfree/westport_mussels_aoa/blob/35e4dc1c9e8c32bea06a034c54593ab6c0804daa/code/23_combined_protected_resources.R#L90

## raster datasets
### Adapted from https://www.mathworks.com/help/fuzzy/zmf.html

#### positive values
zmf_function <- function(raster){
  # calculate minimum value
  min <- terra::minmax(raster)[1,]
  
  # calculate maximum value
  max <- terra::minmax(raster)[2,]
  
  # calculate z-score minimum value
  ## this ensures that no value gets a value of 0
  z_max <- max + (max * 1 / 1000)
  
  # calculate z-scores (more desired values get score of 1 while less desired will decrease till 0)
  z_value <- ifelse(raster[] == min, 1, # if value is equal to minimum, score as 1
                    # if value is larger than minimum but lower than mid-value, calculate based on reduction equation
                    ifelse(raster[] > min & raster[] < (min + z_max) / 2, 1 - 2 * ((raster[] - min) / (z_max - min)) ** 2,
                           # if value is larger than mid-value but lower than maximum, calculate based on equation
                           ifelse(raster[] >= (min + z_max) / 2 & raster[] < z_max, 2*((raster[] - z_max) / (z_max - min)) ** 2,
                                  # if value is equal to maximum, score min - (min * 1 / 1000); otherwise give NA
                                  ifelse(raster[] == z_max, 0, NA))))
  
  # set values back to the original raster
  zvalues <- terra::setValues(raster, z_value)
  
  # return the raster
  return(zvalues)
}

#####################################

#### negative values
zmf_function <- function(raster){
  
  # calculate the absolute value of minimum
  value_add <- abs(terra::minmax(raster)[1])
  
  # calculate the rescaled maximum value
  max_value <- terra::minmax(raster)[2] + value_add
  
  # verify against the range
  range <- terra::minmax(raster)[2] - terra::minmax(raster)[1]
  
  print(c(max_value, range))
  
  # new raster with shifted values
  raster_add <- raster + value_add
  plot(raster_add)
  
  # calculate minimum value
  min <- terra::minmax(raster_add)[1,]
  
  # calculate maximum value
  max <- terra::minmax(raster_add)[2,]
  
  # calculate z-score minimum value
  ## this ensures that no value gets a value of 0
  z_max <- max + (max * 1 / 1000)
  
  # calculate z-scores (more desired values get score of 1 while less desired will decrease till 0)
  z_value <- ifelse(raster_add[] == min, 1, # if value is equal to minimum, score as 1
                    # if value is larger than minimum but lower than mid-value, calculate based on reduction equation
                    ifelse(raster_add[] > min & raster_add[] < (min + z_max) / 2, 1 - 2 * ((raster_add[] - min) / (z_max - min)) ** 2,
                           # if value is larger than mid-value but lower than maximum, calculate based on equation
                           ifelse(raster_add[] >= (min + z_max) / 2 & raster[] < z_max, 2*((raster_add[] - z_max) / (z_max - min)) ** 2,
                                  # if value is equal to maximum, score min - (min * 1 / 1000); otherwise give NA
                                  ifelse(raster_add[] == z_max, 0, NA))))
  
  # set values back to the original raster
  zvalues <- terra::setValues(raster, z_value)
  plot(zvalues)
  
  # return the raster
  return(zvalues)
}

#####################################

## vector datasets
zmf_function <- function(large_pelagic_survey){
  
  # calculate minimum value
  min <- min(large_pelagic_survey$lps_value)
  
  # calculate maximum value
  max <- max(large_pelagic_survey$lps_value)
  
  # calculate z-score minimum value
  ## this ensures that no value gets a value of 0
  z_max <- max + (max * 1 / 1000)
  
  # create a field and populate with the value determined by the z-shape membership scalar
  large_pelagic_survey <- large_pelagic_survey %>%
    # calculate the z-shape membership value (more desired values get a score of 1 and less desired values will decrease till 0.01)
    ## ***Note: in other words, habitats with higher richness values will be closer to 0
    dplyr::mutate(lps_z_value = ifelse(lps_value == min, 1, # if value is equal to minimum, score as 1
                                       # if value is larger than minimum but lower than mid-value, calculate based on scalar equation
                                       ifelse(lps_value > min & lps_value < (min + z_max) / 2, 1 - 2 * ((lps_value - min) / (z_max - min)) ** 2,
                                              # if value is lower than z_maximum but larger than than mid-value, calculate based on scalar equation
                                              ifelse(lps_value >= (min + z_max) / 2 & lps_value < z_max, 2 * ((lps_value - z_max) / (z_max - min)) ** 2,
                                                     # if value is equal to maximum, value is equal to 0.01 [all other values should get an NA]
                                                     ifelse(lps_value == z_max, 0.01, NA)))))
  
  # return the layer
  return(large_pelagic_survey)
}