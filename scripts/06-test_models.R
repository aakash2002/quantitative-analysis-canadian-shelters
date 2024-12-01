#### Preamble ####
# Purpose: Tests the structure and validity of the analysis Toronto outbreak dataset
# Author: Aakash Vaithyanathan
# Date: 28 November 2024
# Contact: aakash.vaithyanathan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `testthat` package must be installed and loaded
# - The `tidyverse` package must be installed and loaded
# - 02-download_data.R must have been run first
# - 03-clean_data.R must have been run second
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the analysis data
data <- read_csv(here::here("data/02-analysis_data/analysis_data.csv"))

# //////////////////////////
# Testing the analysis data
# //////////////////////////

#### Test data ####

# Test for NA Values
test_that("only 'outbreak_over_year' and 'outbreak_over_month' contain NAs", {
  expect_true(all(is.na(data$outbreak_over_year) == is.na(data$outbreak_over_month)))
  expect_true(all(is.na(data$outbreak_over_year) | !is.na(data$outbreak_over_month)))
  expect_false(any(is.na(data$institution_name)))
  expect_false(any(is.na(data$institution_address)))
  expect_false(any(is.na(data$outbreak_setting)))
  expect_false(any(is.na(data$type_of_outbreak)))
  expect_false(any(is.na(data$causative_agent_1)))
  expect_false(any(is.na(data$causative_agent_2)))
  expect_false(any(is.na(data$active)))
  #### Preamble ####
  # Purpose: Models... [...UPDATE THIS...]
  # Author: Rohan Alexander [...UPDATE THIS...]
  # Date: 11 February 2023 [...UPDATE THIS...]
  # Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
  # License: MIT
  # Pre-requisites: [...UPDATE THIS...]
  # Any other information needed? [...UPDATE THIS...]
  
  
  #### Workspace setup ####
  library(tidyverse)
  library(rstanarm)
  
  #### Read data ####
  analysis_data <- read_csv("data/analysis_data/analysis_data.csv")
  
  ### Model data ####
  first_model <-
    stan_glm(
      formula = flying_time ~ length + width,
      data = analysis_data,
      family = gaussian(),
      prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
      prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
      prior_aux = exponential(rate = 1, autoscale = TRUE),
      seed = 853
    )
  
  
  #### Save model ####
  saveRDS(
    first_model,
    file = "models/first_model.rds"
  )
  
  
  

