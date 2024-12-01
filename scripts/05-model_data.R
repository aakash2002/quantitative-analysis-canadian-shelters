#### Preamble ####
# Purpose: Creates various statistical models for analysis for the shelter dataset
# Author: Aakash Vaithyanathan
# Date: 28 November 2024
# Contact: aakash.vaithyanathan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `tidyverse` package must be installed and loaded
# - The `arrow` package must be installed and loaded
# - The `rstanarm` package must be installed and loaded
# - The `loo` package must be installed and loaded
# - 03-clean_data.R must have been run to create the parquet file
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(rstanarm)
library(loo)

# Set seed
set.seed(282024)

#### Read data ####
train_data <- read_parquet(here::here("data/02-analysis_data/analysis_train_shelter_service.parquet"))
test_data <- read_parquet(here::here("data/02-analysis_data/analysis_test_shelter_service.parquet"))

##############
# Build models
##############

# Fit Poisson regression model
poisson_model <- stan_glm(service_user_count ~ population_type + program_model + program_area + overnight_service_type,
                     family = poisson(link = "log"), 
                     data = train_data)

# Fit various Negative Binomial models
neg_binomial_model_basic <- stan_glm(service_user_count ~ population_type + program_model + program_area + overnight_service_type,
                                     family = neg_binomial_2(link = "log"),
                                     data = train_data)

neg_binomial_model_interaction <- stan_glm(service_user_count ~ population_type * program_model + program_area + overnight_service_type,
                                     family = neg_binomial_2(link = "log"),
                                     data = train_data)


# Predictions for each model
poisson_preds <- predict(poisson_model, newdata = test_data)
neg_binomial_basic_preds <- predict(neg_binomial_model_basic, newdata = test_data)
neg_binomial_interaction_preds <- predict(neg_binomial_model_interaction, newdata = test_data)

# Calculate RMSE for each model's predictions
rmse_poisson <- sqrt(mean((poisson_preds - test_data$service_user_count)^2))
rmse_neg_binomial_basic <- sqrt(mean((neg_binomial_basic_preds - test_data$service_user_count)^2))
rmse_neg_binomial_interaction <- sqrt(mean((neg_binomial_interaction_preds - test_data$service_user_count)^2))

# Print RMSE values
cat("RMSE for Poisson model:", rmse_poisson, "\n")
cat("RMSE for Neg Binomial basic model:", rmse_neg_binomial_basic, "\n")
cat("RMSE for Neg Binomial interaction model:", rmse_neg_binomial_interaction, "\n")


#### Save all the models ####
saveRDS(poisson_model, file = "models/poisson_model.rds")
saveRDS(neg_binomial_model_basic, file = "models/neg_binomial_model_basic.rds")
saveRDS(neg_binomial_model_interaction, file = "models/neg_binomial_model_interaction.rds")


