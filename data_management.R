# data management

# move all files to a new subdirectory
for(i in 1:length(files)){
  # move from the current raw directory
  file.rename(from = file.path(old_dir, files[i]),
              # and move to the new bathymetry subdirectory
              to = file.path(new_dir, files[i]))
}

#####################################

# rename directory
get_file_name <- list.files(data_dir,
                            # get the element that has "pattern" in it
                            pattern = "pattern")

file.rename(from = file.path(data_dir, get_file_name),
            # rename it to be shorter and more understandable
            to = file.path(data_dir, "new_name"))

# delete unzipped directory without name change
unlink(file.path(data_dir, get_file_name), recursive = T)

#####################################

# examine all subdirectories in data directory
list.files(data_dir)

#####################################

# create reference table
table <- data.frame(field1 = character(),
                    field2 = numeric(),
                    field3 = numeric(),
                    field4 = numeric(),
                    field5 = numeric())

#####################################

# combine datas by rows
data_row <- rbind(data1,
                  data2,
                  data3)

# combine data by columns
data_column <- cbind(data1,
                     data2,
                     data3)

#####################################

# remove data
rm(data)