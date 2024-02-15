# Define and fit boosted tree model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(xgboost)

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
bt_spec <- boost_tree(
  mode = "regression",
  min_n = tune(),
  mtry = tune(), 
  learn_rate = tune()
) |> 
  set_engine("xgboost")

# define workflows ----
bt_wf <- workflow() |> 
  add_model(bt_spec) |> 
  add_recipe(recipe)

# hyperparameter tuning values ----
bt_params <- parameters(bt_spec)  |> 
  update(mtry = mtry(c(1, 14))) 
bt_grid <- grid_regular(bt_params, levels = 5)

# fit workflows/models ----
bt_tuned <- bt_wf |> 
  tune_grid(pregnancy_folds, grid = bt_grid,
            control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(bt_tuned, file = here("results/tuned_bt.rda"))