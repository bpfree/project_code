# geometric mean

## examples of code
### https://github.com/bpfree/oregon_case-study_sensitivity-uncertainty/blob/main/code/20_natural_resources_submodel.R
### https://github.com/bpfree/oregon_case-study_sensitivity-uncertainty/blob/main/code/21_fisheries_submodel.R
### https://github.com/bpfree/westport_mussels_aoa/blob/35e4dc1c9e8c32bea06a034c54593ab6c0804daa/code/25_national_security_submodel.R

## geometric mean weight
nr_wt <- 1/3

#####################################

## calculate geometric mean for natural resources submodel
oregon_natural_resources <- oregon_hex %>%
  dplyr::left_join(x = .,
                   y = protected_species,
                   by = "index") %>%
  dplyr::left_join(x = .,
                   y = habitat_values,
                   by = "index") %>%
  dplyr::left_join(x = .,
                   y = marine_bird_value,
                   by = "index") %>%
  
  # calculate the geometric mean
  ## geometric mean = nth root of the product of the variable values
  dplyr::mutate(nr_geom_mean = (species_product_value ^ nr_wt) * (habitat_value ^ nr_wt) * (marine_bird_value ^ nr_wt)) %>%
  
  # select the fields of interest
  dplyr::select(index,
                leatherback_value,
                killerwhale_value,
                humpback_ca_value,
                humpback_mx_value,
                bluewhale_value,
                species_product_value,
                efhca_value,
                rreef_map_value,
                rreef_prob_value,
                deep_coralsponge_value,
                continental_shelf_value,
                methane_bubble_value,
                habitat_value,
                marine_bird_value,
                nr_geom_mean) %>%
  # rename the geometry field
  dplyr::rename(geom = geom.x)