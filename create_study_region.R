# create study region

## examples of code
### https://github.com/bpfree/westport_mussels_aoa/blob/main/code/04_create_study_area.R
### https://github.com/bpfree/oregon_case-study_sensitivity-uncertainty/blob/main/code/2_study_area.R

#####################################

# Hexagon area = ((3 * sqrt(3))/2) * side length ^ 2 (https://pro.arcgis.com/en/pro-app/latest/tool-reference/data-management/generatetesellation.htm)
# 1 acre equals approximately 4064.86 square meters
# 10 acres = 40468.6 square meters
# 40468.6 = ((3 * sqrt(3))/2) * side length ^ 2
# 40468.6 * 2 = 3 * sqrt(3) * side length ^ 2 --> 80937.2
# 80937.2 / 3 = sqrt(3) * side length ^ 2 --> 26979.07
# 26979.07 ^ 2 = 3 * side length ^ 4 --> 727870218
# 727870218 / 3 = side length ^ 4 --> 242623406
# 242623406 ^ (1/4) = side length --> 124.8053

# Create 10-acre grid around study region
study_region_grid <- sf::st_make_grid(x = study_region,
                                      ## see documentation on what cellsize means when relating to hexagons: https://github.com/r-spatial/sf/issues/1505
                                      ## cellsize is the distance between two vertices (short diagonal --> d = square root of 3 * side length)
                                      ### So in this case, square-root of 3 * 124.8053 = 1.73205080757 * 124.8053 = 216.1691
                                      cellsize = 216.1691,
                                      # make hexagon (TRUE will generate squares)
                                      square = FALSE,
                                      # make hexagons orientation with a flat topped (FALSE = pointy top)
                                      flat_topped = TRUE) %>%
  # convert back as sf
  sf::st_as_sf() %>%
  # change to correct coordinate reference system (EPSG:26918 -- NAD83 / UTM 18N)
  sf::st_transform(x = ., crs = crs)

# subset by location: hexagonal grids that intersect with study area
study_region_hex <- study_region_grid[study_region, ] %>%
  # add field "index" that will be populated with the row_number
  dplyr::mutate(index = row_number())

#####################################