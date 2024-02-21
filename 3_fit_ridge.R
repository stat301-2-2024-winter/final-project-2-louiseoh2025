# Define and fit ridge regression

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(glmnet)

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
ridge_spec <- linear_reg(penalty = tune(), 
                         mixture = 1) |> 
  set_engine("glmnet") |> 
  set_mode("regression")

# define workflows ----
ridge_wf <- workflow() |> 
  add_model(ridge_spec) |> 
  add_recipe(recipe_np)
ridge_wf2 <- workflow() |> 
  add_model(ridge_spec) |> 
  add_recipe(recipe2_np)

# hyperparameter tuning grid ----
ridge_params <- hardhat::extract_parameter_set_dials(ridge_spec)
# ridge_params <- parameters(ridge_spec)

# build tuning grid
ridge_grid <- grid_regular(ridge_params, levels = 5)

# fit workflows/models ----
ridge_tuned <- ridge_wf |> 
  tune_grid(
    resamples = pregnancy_folds,
    grid = ridge_grid,
    metrics = metric_set(rmse),
    control = control_grid(save_workflow = TRUE)
  )
ridge_tuned2 <- ridge_wf2 |> 
  tune_grid(
    resamples = pregnancy_folds,
    grid = ridge_grid,
    metrics = metric_set(rmse),
    control = control_grid(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(ridge_tuned, ridge_tuned2, file = here("results/tuned_ridge.rda"))
