# basic vector geospatial code

## load data
data <- sf::st_read(dsn = data.gpkg,
                    layer = "layer_name")

#####################################

## convert to sf
data_sf <- data %>%
  sf::st_as_sf(x = data,
               coords = c("long_field",
                          "lat_field"),
               crs = "EPSG:XXXX",
               remove = F) # if want to keep original fields

#####################################

## export data
sf::st_write(obj = data,
             dsn = data_gpkg,
             layer = paste(region, export_name, date, sep = "_"),
             append = F)

#####################################

# change coordinate reference system
vector_crs <- data %>%
  sf::st_transform(x = .,
                   crs = "EPSG:XXXX")

#####################################

# clip data
data_clip <- data %>%
  rmapshaper::ms_clip(target = .,
                      clip = clip)

#####################################

# dissolve data
data_clip <- data %>%
  rmapshaper::ms_dissolve(input = data,
                          field = "field")

#####################################

# spatial join
data <- data[data_join, ] %>%
  sf::st_join(x = .,
              y = data_join,
              join = st_intersects) %>%
  # select fields of interest
  dplyr::select(field1, field2)

#####################################

# buffer data
data_buffer <- data %>%
  sf::st_buffer(x = data,
                dist = buffer_distance)

#####################################

# erase data
data_erase <- data %>%
  rmapshaper::ms_erase(target = .,
                       erase = erase)

#####################################

# convert data type
data_multiline <- data %>%
  sf::st_cast(x = data,
              to = "MULTILINESTRING") # use ?sf::st_cast() to see data types to change