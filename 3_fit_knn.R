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

# model specifications ----
knn_spec <- nearest_neighbor(mode = "regression",
                             neighbors = tune()) |> 
  set_engine("kknn")

# define workflows ----
knn_wf <- workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(recipe_tree)
knn_wf2 <- workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(recipe2_tree)

# hyperparameter tuning values ----
knn_params <- parameters(knn_spec)
knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflows/models ----
knn_tuned <- knn_wf |> 
  tune_grid(pregnancy_folds, grid = knn_grid,
            control = control_grid(save_workflow = TRUE))
knn_tuned2 <- knn_wf2 |> 
  tune_grid(pregnancy_folds, grid = knn_grid,
            control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(knn_tuned, knn_tuned2, file = here("results/tuned_knn.rda"))