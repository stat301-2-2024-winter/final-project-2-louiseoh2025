# Define and fit k nearest neighbor

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(kknn)

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

## USING RECIPE 1 tree -----
# model specification
knn_spec <- nearest_neighbor(mode = "regression",
                             neighbors = tune()) |> 
  set_engine("kknn")
# define workflow
knn_workflow1 <- workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(recipe1_tree)
# hyperparameter tuning grid
knn_params <- parameters(knn_spec)
# build tuning grid
knn_grid <- grid_regular(knn_params, levels = 5)
# fit workflow/model
knn_tuned1 <- knn_workflow1 |> 
  tune_grid(
    pregnancy_folds, 
    grid = knn_grid,
    control = control_grid(save_workflow = TRUE)
    )

## USING RECIPE 2 tree -----
# model specification
knn_spec <- nearest_neighbor(mode = "regression",
                             neighbors = tune()) |> 
  set_engine("kknn")
# define workflow
knn_workflow2 <- workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(recipe2_tree)
# hyperparameter tuning grid
knn_params <- parameters(knn_spec)
# build tuning grid
knn_grid <- grid_regular(knn_params, levels = 5)
# fit workflow/model
knn_tuned2 <- knn_workflow2 |> 
  tune_grid(
    pregnancy_folds, 
    grid = knn_grid,
    control = control_grid(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(knn_tuned1, knn_tuned2, file = here("results/tuned_knn.rda"))