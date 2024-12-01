#### Preamble ####
# Purpose: Tests the structure and validity of the simulated Canada Shelter Service dataset
# Author: Aakash Vaithyanathan
# Date: 28 November 2024
# Contact: aakash.vaithyanathan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `testthat` package must be installed and loaded
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? None


#### Workspace setup ####
library(testthat)
library(tidyverse)

# Set seed
set.seed(282024)

# Load simulated data
data <- read_csv(here::here("data/00-simulated_data/simulated_shelter_data.csv"))

# //////////////////////////
# Testing the simulated data
# //////////////////////////

# Define allowed values for validation
allowed_shelters <- c("Salvation Army", "Covenant House", "CAIRD", "YMCA", 
                      "Shepherds of Good Hope", "Kennedy House Youth Services")
allowed_cities <- c("Toronto", "Scarborough", "Mississauga", "Whitby", "Oakvile")
allowed_populations <- c("Men", "Women", "Youth", "Elderly", "Indigenous")

# Tests for structure and validity of shelter data

test_that("Data structure is correct", {
  expect_true(is.data.frame(data)) 
  expect_equal(nrow(data), 300)    
  expect_equal(ncol(data), 6)
})

test_that("year column is valid", {
  expect_true(is.numeric(data$year))
  expect_true(all(data$year >= 2000 & data$year <= 2024))
})

test_that("month column is valid", {
  expect_true(is.numeric(data$month))
  expect_true(all(data$month >= 1 & data$month <= 12))
})

test_that("shelter_name column is valid", {
  expect_type(data$shelter_name, "character")
  expect_true(all(data$shelter_name %in% allowed_shelters))
})

test_that("city column is valid", {
  expect_type(data$city, "character")
  expect_true(all(data$city %in% allowed_cities))
})

test_that("population_type column is valid", {
  expect_type(data$population_type, "character")
  expect_true(all(data$population_type %in% allowed_populations))
})

test_that("count_seeking_shelter column is valid", {
  expect_true(is.numeric(data$count_seeking_shelter))
  expect_true(all(data$count_seeking_shelter >= 100 & data$count_seeking_shelter <= 1000))
})

test_that("no missing values are present", {
  expect_false(any(is.na(data)))
})

test_that("dataset has at least one row", {
  expect_gt(nrow(data), 0)
})

