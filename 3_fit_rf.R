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
  rand_forest(mode = "regression",
              trees = 1000, 
              min_n = tune(),
              mtry = tune()) |> 
  set_engine("ranger")

# define workflows ----
rf_wf <- workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(recipe_tree)
rf_wf2 <- workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(recipe2_tree)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_spec) |> 
  update(mtry = mtry(c(1, 15)))
# change hyperparameter ranges
rf_params <- parameters(rf_spec) |> 
  update(mtry = mtry(c(1, 15))) 
rf_params2 <- parameters(rf_spec) |> 
  update(mtry = mtry(c(1, 16))) 

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5) 
rf_grid2 <- grid_regular(rf_params2, levels = 5) 

# fit workflows/models ----
rf_tuned <- rf_wf |> 
  tune_grid(pregnancy_folds, grid = rf_grid,
            control = control_grid(save_workflow = TRUE))
rf_tuned2 <- rf_wf2 |> 
  tune_grid(pregnancy_folds, grid = rf_grid2,
            control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(rf_tuned, rf_tuned2, file = here("results/tuned_rf.rda"))