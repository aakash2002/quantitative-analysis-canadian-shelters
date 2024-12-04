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
# - 03-clean_data.R must have been run to create the parquet file
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(rstanarm)

# Set seed
set.seed(282024)

#### Read data ####
train_data <- read_parquet(here::here("data/02-analysis_data/analysis_train_shelter_service.parquet"))
test_data <- read_parquet(here::here("data/02-analysis_data/analysis_test_shelter_service.parquet"))

##############
# Build models
##############
# Fit Poisson regression model
poisson_model <- stan_glm(service_count ~ demographic + shelter_type + service_type,
                     family = poisson(link = "log"),
                     prior = normal(0, 2.5, autoscale = TRUE),
                     data = train_data)

# Fit various Negative Binomial models
neg_binomial_model_basic <- stan_glm(service_count ~ demographic + shelter_type + service_type,
                                     family = neg_binomial_2(link = "log"),
                                     prior = normal(0, 2.5, autoscale = TRUE),
                                     prior_aux = exponential(1, autoscale=TRUE),
                                     data = train_data)

neg_binomial_model_interaction <- stan_glm(service_count ~ demographic * shelter_type + service_type,
                                     family = neg_binomial_2(link = "log"),
                                     prior = normal(0, 2.5, autoscale = TRUE),
                                     prior_aux = exponential(1, autoscale=TRUE),
                                     data = train_data)


#### Save all the models ####
saveRDS(poisson_model, file = "models/poisson_model.rds")
saveRDS(neg_binomial_model_basic, file = "models/neg_binomial_model_basic.rds")
saveRDS(neg_binomial_model_interaction, file = "models/neg_binomial_model_interaction.rds")


