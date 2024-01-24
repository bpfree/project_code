# data inspection

## vector
### make all valid geometries
data <- data %>%
  sf::st_make_valid(x = data)

### first data rows
utils::head(head, 10) # first 10 rows

### pull data rows
dplyr::slice(data, 10) # first 10 rows

### remove row data
dplyr::slice(data, -1)

### field names
names(data)

### relocate fields
data <- data %>%
  dplyr::relocate(field_to_move,
                  .before = field_after_moved_field)

### rename fields
data <- data %>%
  dplyr::rename("new_name_field1" = "old_name_field1",
                "new_name_field2" = "old_name_field2",
                "new_name_field3" = "old_name_field3")

## Check units for data
sf::st_crs(data, parameters = TRUE)$units_gdal

#####################################

## raster
### minimum and maximum values
terra::minmax(raster)[1] # minimum value
terra::minmax(raster)[2] # maximum value

# spatial extent
ext(raster)
print(terra::ext(raster))

# dimensions
dim(raster)

#####################################

## databases
### inspect layers within geodatabases and geopackages
sf::st_layers(dsn = gdb,
              do_count = T)
sf::st_layers(dsn = gpkg,
              do_count = T)

### vector datasets
vector_data <- which(!is.na(sf::st_layers(dsn = gdb,
                                          do_count = T)$geomtype == "NA"))

## see length of data layers
length(sf::st_layers(dsn = gdb,
                     do_count = T)[[1]])