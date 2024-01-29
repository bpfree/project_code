# data cleaning

## omit NA data
data_real <- data %>%
  na.omit()

## recode data within field
data <- data %>%
  dplyr::recode(field,
                "old_name1" = "new_name1",
                "old_name2" = "new_name2",
                "old_name3" = "new_name3")

#####################################

# query data
## character
data_query <- data %>%
  dplyr::filter(field = "criteria")

## numeric
data_query <- data %>%
  dplyr::filter(field == 1)

## not values
data_all_but <- dplyr::filter(!field %in% c("value1", "value2", "value3"))

#####################################

# summarise data
data_summarise <- data %>%
  dplyr::group_by(field1) %>%
  dplry::summarise()

#####################################

# create new field
data <- data %>%
  dplyr::mutate(new_field = "name")

#####################################

# rename fields
data <- data %>%
  dplyr::rename("new_name_field1" = "old_name_field1",
                "new_name_field2" = "old_name_field2",
                "new_name_field3" = "old_name_field3")

#####################################

# distinct values
data_distinct <- data %>%
  dplyr::distinct()

#####################################