#### Preamble ####
# Purpose: Simulates a dataset of Canada Shelter Services
# Author: Aakash
# Date: 28 November, 2024
# Contact: aakash.vaithyanathan@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
set.seed(282024)


#### Simulate data ####
# Set the number of random dates you want to generate
num_rows <- 300

shelter_data <-
  tibble(
    year = as.integer(runif(
      n = num_rows,
      min = 2000,
      max = 2024
    )),
    month = as.integer(runif(
      n = num_rows,
      min = 1,
      max = 12
    )),
    shelter_name = sample(
      c("Salvation Army", "Covenant House", "CAIRD", "YMCA", "Shepherds of Good Hope", "Kennedy House Youth Services"), 
      size = num_rows, replace = TRUE
    ),
    city = sample(
      c("Toronto", "Scarborough", "Mississauga", "Whitby", "Oakvile"), 
      size = num_rows, replace = TRUE
    ),
    population_type = sample(
      c("Men", "Women", "Youth", "Elderly", "Indigenous"), 
      size = num_rows, replace = TRUE
    ),
    count_seeking_shelter = as.integer(runif(
      n = num_rows,
      min = 100,
      max = 1000
    )),
  )

#### Save data ####
write_csv(shelter_data, "data/00-simulated_data/simulated_shelter_data.csv")
