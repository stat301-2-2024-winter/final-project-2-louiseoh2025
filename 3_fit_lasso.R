# Define and fit lasso regression

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
lasso_spec <- linear_reg(penalty = tune(), 
                      mixture = 0) |> 
  set_engine("glmnet") |> 
  set_mode("regression")

# define workflows ----
lasso_wf <- workflow() |> 
  add_model(lasso_spec) |> 
  add_recipe(recipe_np)
lasso_wf2 <- workflow() |> 
  add_model(lasso_spec) |> 
  add_recipe(recipe2_np)

# hyperparameter tuning grid ----
lasso_params <- hardhat::extract_parameter_set_dials(lasso_spec)
# lasso_params <- parameters(lasso_spec)

# build tuning grid
lasso_grid <- grid_regular(lasso_params, levels = 5)

# fit workflows/models ----
lasso_tuned <- lasso_wf |> 
  tune_grid(
    resamples = pregnancy_folds,
    grid = lasso_grid,
    metrics = metric_set(rmse),
    control = control_grid(save_workflow = TRUE)
  )
lasso_tuned2 <- lasso_wf2 |> 
  tune_grid(
    resamples = pregnancy_folds,
    grid = lasso_grid,
    metrics = metric_set(rmse),
    control = control_grid(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(lasso_tuned, lasso_tuned2, file = here("results/tuned_lasso.rda"))
