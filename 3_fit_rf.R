# Define and fit random forest

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(ranger)

# set seed for random process
set.seed(100)

# handle common conflicts
tidymodels_prefer()

# parallel over
library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# load training data
load(here("results/pregnancy_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("results/pregnancy_recipes.rda"))

# model specifications ----
rf_spec <- 
  rand_forest(
    mode = "regression",
    trees = 1000, 
    min_n = tune(),
    mtry = tune()
  ) |> 
  set_engine("ranger")

# define workflows ----
rf_wf <- workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(recipe)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_spec) |> 
  update(mtry = mtry(c(1, 14)))

# change hyperparameter ranges
rf_params <- parameters(rf_spec) |> 
  # N:= maximum number of random predictor columns we want to try 
  # should be less than the number of available columns
  update(mtry = mtry(c(1, 10))) 

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5) # 125 parameters?
# grid_random(rf_params, size = 20)
# grid_latin_hypercube(rf_params, size = 20) good for many params

# fit workflows/models ----
rf_tuned <- rf_wf |> 
  tune_grid(pregnancy_folds, grid = rf_grid,
            control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(rf_tuned, file = here("results/tuned_rf.rda"))