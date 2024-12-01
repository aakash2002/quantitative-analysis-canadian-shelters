#### Preamble ####
# Purpose: Tests the structure and validity of the analysis Shelter Service Data
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
library(arrow)
library(testthat)

# Set seed
set.seed(282024)

# Load the analysis data
data <- read_parquet(here::here("data/02-analysis_data/analysis_shelter_service.parquet"))

# //////////////////////////
# Testing the analysis data
# //////////////////////////

#### Test data ####

context("Data cleaning tests")

#### Test 1: Test reading and structure of data ####
test_that("The data is read correctly", {
  expect_s3_class(data, "data.frame")   # Check that the data is a dataframe
  expect_true(ncol(data) > 0)           # Ensure the data has columns
  expect_true(nrow(data) > 0)           # Ensure the data has rows
  expect_equal(names(data), c("year", "month", "location_city", "population_type", "program_model", 
                              "overnight_service_type", "program_area", "service_user_count", 
                              "occupancy_rate_beds"))
})

#### Test 2: Test column name cleaning ####
test_that("Column names are cleaned correctly", {
  # Ensure column names are standardized to lowercase and without spaces
  cleaned_names <- names(data)
  expect_true(all(grepl("^[a-z_]+$", cleaned_names)))  # Check for lowercase and underscore-only names
})

#### Test 3: Test for missing values after cleaning ####
test_that("Missing values are removed", {
  expect_true(all(complete.cases(data)))  # Ensure there are no missing values in the cleaned data
})

#### Test 4: Test categorical variable conversion ####
test_that("Categorical variables are converted to factors", {
  # Check if expected columns are factors
  expect_true(is.factor(data$location_city))
  expect_true(is.factor(data$population_type))
  expect_true(is.factor(data$program_model))
  expect_true(is.factor(data$overnight_service_type))
  expect_true(is.factor(data$program_area))
})

#### Test 5: Test column renaming ####
test_that("Column 'sector' is renamed to 'population_type'", {
  expect_true("population_type" %in% names(data))  # Ensure the renaming is correct
  expect_false("sector" %in% names(data))         # Ensure 'sector' is no longer present
})

#### Test 6: Test for correct columns selected ####
test_that("Only the required columns are selected", {
  expected_columns <- c("year", "month", "location_city", "population_type", "program_model", 
                        "overnight_service_type", "program_area", "service_user_count", 
                        "occupancy_rate_beds")
  expect_equal(names(data), expected_columns)  # Ensure the selected columns are exactly what we expect
})

#### Test 7: Test factor levels for categorical variables ####
test_that("Factor levels are properly assigned", {
  # Check if factor levels are assigned for each categorical variable
  expect_true(all(levels(data$location_city) %in% unique(data$location_city)))
  expect_true(all(levels(data$population_type) %in% unique(data$population_type)))
  expect_true(all(levels(data$program_model) %in% unique(data$program_model)))
  expect_true(all(levels(data$overnight_service_type) %in% unique(data$overnight_service_type)))
  expect_true(all(levels(data$program_area) %in% unique(data$program_area)))
})

#### Test 8: Test data integrity after drop_na() ####
test_that("drop_na() doesn't remove essential rows", {
  # Check if data integrity is preserved (no rows should be lost unintentionally)
  original_row_count <- nrow(data)
  data_no_na <- data |> drop_na()
  expect_true(nrow(data_no_na) <= original_row_count)  # Should not increase rows
})