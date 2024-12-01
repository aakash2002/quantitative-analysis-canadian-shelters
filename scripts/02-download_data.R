#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto about Daily Shelter Service
# Author: Aakash Vaithyanathan
# Date: 28 November 2024
# Contact: aakash.vaithyanathan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `opendatatoronto` package must be installed and loaded
# Any other information needed? None


#### Workspace setup ####
library(opendatatoronto)
# Set seed
set.seed(282024)

# Get package from Open Data Toronto

package <- show_package("21c83b32-d5a8-4106-a54f-010dbe49f6f2")

# Get all resources for this package
resources <- list_package_resources("21c83b32-d5a8-4106-a54f-010dbe49f6f2")

# Identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources

datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# Load the first datastore resource as a sample
data <- filter(datastore_resources, row_number()==5) %>% get_resource()

#### Save data ####
write_csv(data, "data/01-raw_data/raw_daily_shelter_data.csv")

         
