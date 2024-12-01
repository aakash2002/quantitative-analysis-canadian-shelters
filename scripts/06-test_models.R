#### Preamble ####
# Purpose: Test the various models predictive power on testing data of Canada shelter service
# Author: Aakash Vaithyanathan
# Date: 30 November, 2024
# Contact: aakash.vaithyanathan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The 'tidyverse' package must be loaded
# - The 'arrow' package must be loaded
# - The 'rstanarm' package must be loaded
# - 05-model_data.R must be run first
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(rstanarm)

# Set seed
set.seed(282024)

#### Read data ####
test_data <- read_parquet(here::here("data/02-analysis_data/analysis_test_shelter_service.parquet"))

#### Load the trained models data ####
poisson_model <- readRDS(here::here("models/poisson_model.rds"))
neg_binomial_model_basic <- readRDS(here::here("models/neg_binomial_model_basic.rds"))
neg_binomial_model_interaction <- readRDS(here::here("models/neg_binomial_model_interaction.rds"))


#### Run the model on test data ####

# Predictions for each model
poisson_preds <- predict(poisson_model, newdata = test_data)
neg_binomial_basic_preds <- predict(neg_binomial_model_basic, newdata = test_data)
neg_binomial_interaction_preds <- predict(neg_binomial_model_interaction, newdata = test_data)

# Calculate RMSE for each model's predictions
rmse_poisson <- sqrt(mean((poisson_preds - test_data$service_user_count)^2))
rmse_neg_binomial_basic <- sqrt(mean((neg_binomial_basic_preds - test_data$service_user_count)^2))
rmse_neg_binomial_interaction <- sqrt(mean((neg_binomial_interaction_preds - test_data$service_user_count)^2))

# Calculate MAE for each model's predictions
mae_poisson <- mean(abs(poisson_preds - test_data$service_user_count))
mae_neg_binomial_basic <- mean(abs(neg_binomial_basic_preds - test_data$service_user_count))
mae_neg_binomial_interaction <- mean(abs(neg_binomial_interaction_preds - test_data$service_user_count))

# Print MAE values
cat("MAE for Poisson model:", mae_poisson, "\n")
cat("MAE for Basic Negative Binomial model:", mae_neg_binomial_basic, "\n")
cat("MAE for Interaction Negative Binomial model:", mae_neg_binomial_interaction, "\n")
# Print RMSE values
cat("RMSE for Poisson model:", rmse_poisson, "\n")
cat("RMSE for Neg Binomial basic model:", rmse_neg_binomial_basic, "\n")
cat("RMSE for Neg Binomial interaction model:", rmse_neg_binomial_interaction, "\n")
  
  

