#### Preamble ####
# Purpose: Cleans the raw Canada Daily Shelter Data
# Author: Aakash Vaithyanathan
# Date: 28 November 2024
# Contact: aakash.vaithyanathan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `tidyverse` package must be installed and loaded
# - The `arrow` package must be installed and loaded
# - The `caret` package must be installed and loaded
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(caret)

# Set seed
set.seed(282024)

#### Clean data ####
raw_data <- read_csv("data/01-raw_data/raw_daily_shelter_data.csv")

# Clean up names and remove missing values
cleaned_data <-
  raw_data |>
  janitor::clean_names() |> 
  separate(col = occupancy_date,
           into = c("year", "month"),
           sep = "-")

# Select required columns for analysis
# Since the dataset either has rows for occupancy type BED or ROOM, we choose only occupancy_type BEDS for our study 
cleaned_data <- cleaned_data |>
  select(c(year, month, location_city, sector, program_model, overnight_service_type, program_area, service_user_count, occupancy_rate_beds))

# Remove missing values
cleaned_data <- cleaned_data |> drop_na()

# Convert the categorical variables into factors
cleaned_data$location_city <- as.factor(cleaned_data$location_city)
cleaned_data$sector <- as.factor(cleaned_data$sector)
cleaned_data$program_model <- as.factor(cleaned_data$program_model)
cleaned_data$overnight_service_type <- as.factor(cleaned_data$overnight_service_type)
cleaned_data$program_area <- as.factor(cleaned_data$program_area)

# Rename sector column
cleaned_data <- cleaned_data |>
  rename(population_type = sector)

# Re-level the data to use 'Men' as the baseline
cleaned_data$population_type <- relevel(cleaned_data$population_type, ref = "Men")

# Split data into training and testing dataset.
# We use an 80:20 split where 80% is for training and 20% is for testing.
trainIndex <- createDataPartition(cleaned_data$service_user_count, p = 0.8, list = FALSE)
trainData <- cleaned_data[trainIndex, ]
testData <- cleaned_data[-trainIndex, ]

#### Save data ####
write_parquet(cleaned_data, "data/02-analysis_data/analysis_shelter_service.parquet")
write_parquet(trainData, "data/02-analysis_data/analysis_train_shelter_service.parquet")
write_parquet(testData, "data/02-analysis_data/analysis_test_shelter_service.parquet")
