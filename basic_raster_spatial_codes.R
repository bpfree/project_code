# basic raster geospatial code

## load data
### raster data
raster <- terra::rast(paste(data_dir, "layer.tif", sep = "/"))

#####################################

## export data
### raster
terra::writeRaster(x = raster,
                   filename = file.path(data_dir, "raster.grd"),
                   overwrite = T)

#####################################

# create raster grid
## Square
### Grid with X meter cell size
#### Create a template raster that has the extent of the study area
rast_temp <- terra::rast(study_area,
                         # use the extent of the marine study area
                         extent = study_area,
                         # give raster to have resolution of X meters
                         resolution = X,
                         # have coordinate reference system as the study area (EPSG:5070)
                         crs = crs(study_area))

#####################################

#### Create raster filed with the data from the study area
rast <- terra::rasterize(x = study_area,
                         y = rast_temp,
                         field = "value")

#####################################

# convert boundary to a polygon
boundary <- terra::as.polygons(x = raster) %>%
  # set as sf
  sf::st_as_sf() %>%
  # create field called "boundary"
  dplyr::mutate(boundary = "boundary") %>%
  # select the "boundary" field
  dplyr::select(boundary) %>%
  # group all rows by the different elements with "boundary" field -- this will create a row for the grouped data
  dplyr::group_by(boundary) %>%
  # summarise all those grouped elements together -- in effect this will create a single feature
  dplyr::summarise()

#####################################

# change coordinate reference system
## raster
raster_crs <- terra::project(x = raster, y = "EPSG:XXXX")
cat(crs(raster_crs))