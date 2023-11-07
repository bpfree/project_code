########################################################
### 0. Webscrape Data -- Texas County Shipping Lanes ###
########################################################

# Clear environment
rm(list = ls())

# Calculate start time of code (determine how long it takes to complete all code)
start <- Sys.time()

#####################################
#####################################

# Load packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(docxtractr,
               dplyr,
               elsa,
               fasterize,
               fs,
               ggplot2,
               janitor,
               ncf,
               paletteer,
               pdftools,
               plyr,
               purrr,
               raster,
               RColorBrewer,
               reshape2,
               rgdal,
               rgeoda,
               rgeos,
               rmapshaper,
               rnaturalearth, # use devtools::install_github("ropenscilabs/rnaturalearth") if packages does not install properly
               RSelenium,
               sf,
               shadowr,
               sp,
               stringr,
               terra, # is replacing the raster package
               tidyr,
               tidyverse)

#####################################
#####################################

# Set directories
## download directory
download_dir <- "~/downloads"

## output directory
data_dir <- "data/a_raw_data"

## create county data for shipping data
dir.create(paste0(data_dir, "/",
                  "tx_county"))

## county shipping data directory
tx_county_dir <- "data/a_raw_data/tx_county"

#####################################
#####################################

# Webscrape set-up
## Process uses RSelenium package (learn more about basics here: https://cran.r-project.org/web/packages/RSelenium/vignettes/basics.html)
### Another helpful tutorial: https://joshuamccrain.com/tutorials/web_scraping_R_selenium.html
### Firefox profile (based on this link: https://yizeng.me/2014/05/23/download-pdf-files-automatically-in-firefox-using-selenium-webdriver/)
fprof <- RSelenium::makeFirefoxProfile(list(
  # detail level for download (0 = Desktop, 1 = systems default downloads location, 2 = custom folder.)
  browser.download.folderList = 2,
  # location for data download
  browser.download.dir = data_dir,
  # stores a comma-separated list of MIME types to save to disk without asking what to use to open the file
  browser.helperApps.neverAsk.saveToDisk = "application/pdf",
  # disable PDF javascript so that PDFs are not displayed
  pdfjs.disabled = TRUE,
  # turn off scan and loading of any additionally added plug-ins
  plugin.scan.plid.all = FALSE,
  # high number defined for version of Adobe Acrobat
  plugin.scan.Acrobat = "99.0"))

#####################################

# Launch RSelenium server and driver
rD <- RSelenium::rsDriver(browser="firefox",
                          # set which version of browser
                          version = "latest",
                          # Chrome version (turn off as Firefox will be used)
                          chromever = NULL,
                          # set which version of Gecko to use
                          geckover = "latest",
                          # status messages
                          verbose = TRUE,
                          # populate with the Firefox profile
                          extraCapabilities = fprof)

## Remote driver
remDr <- rD[["client"]]
remDr$open(silent = TRUE)

#####################################
#####################################

## Texas shipping channels (i.e., state waters)
## Source: RRC (all layers by county: https://www.rrc.texas.gov/resource-center/research/data-sets-available-for-download/)
## Actual county data are obtainable from here: https://mft.rrc.texas.gov/link/f9112008-ab1f-4550-94c9-e2546d1bbb59)
## List of county FIPS codes: https://www.rrc.texas.gov/about-us/locations/oil-gas-counties-districts/
## FIPS Codes for the 5 affected counties
#### Brazoria -- 039
#### Chambers -- 071
#### Galveston -- 167
#### Harris -- 201
#### Jefferson -- 245

county_list <- list("039",
                    "071",
                    "167",
                    "201",
                    "245")

### Click the box next to the five county files then click "Download" box at bottom of page
### Download will contain five zipped subdirectories (one for each county)

# Base URL
base_url <- "https://mft.rrc.texas.gov/link/f9112008-ab1f-4550-94c9-e2546d1bbb59"

# Navigate to page
remDr$navigate(base_url)
Sys.sleep(5)

#####################################

# Prepare window
remDr$maxWindowSize()
Sys.sleep(2)

#####################################

# i <- 2
for(i in 1:length(county_list)){
  start2 <- Sys.time()
  
  county_data <- remDr$findElement(using = "link text",
                                   value = paste0("Shp", county_list[i], ".zip"))
                                   
  county_data$clickElement()
  
  Sys.sleep(8)
  
  print(paste("Iteration", i, "of", length(county_list), "takes", Sys.time() - start2, units(Sys.time() - start2), "to download", county_list[i], "county data", sep = " "))

  # Move data to correct directory
  file.rename(from=file.path(download_dir, paste0("Shp", county_list[i], ".zip")),  # Make default download directory flexible
              # send to the raw data directory
              to=file.path(tx_county_dir, paste0("Shp", county_list[i], ".zip")))
  
  # Unzip the data
  ## grab text before ".zip" and keep only text before that
  new_dir_name <- sub(".zip", "", paste0("Shp", county_list[i], ".zip"))
  
  ## create new directory for data
  new_dir <- file.path(tx_county_dir, new_dir_name)
  
  ## unzip the file
  unzip(zipfile = file.path(tx_county_dir, paste0("Shp", county_list[i], ".zip")),
        # export file to the new data directory
        exdir = tx_county_dir)
  
  list.files(data_dir)
  
  ## remove original zipped file
  file.remove(file.path(tx_county_dir, paste0("Shp", county_list[i], ".zip")))
  
  }

#####################################
#####################################

# Close RSelenium servers
remDr$close()
rD$server$stop()

#####################################
#####################################

# calculate end time and print time difference
print(Sys.time() - start) # print how long it takes to calculate
