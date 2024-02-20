# RECIPES

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# set seed for random process
set.seed(100)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("results/pregnancy_split.rda"))

# standard recipe - lasso, ridge, bt
recipe <- recipe(birth_weight ~ ., data = pregnancy_train) |> 
  # filter out variables have have zero variance
  step_zv(all_predictors()) |> 
  # center and scale all predictors
  step_normalize(all_numeric_predictors()) |> 
  # one-hot encode all categorical predictors
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  # remove uniqueID and date
  step_rm(delivery_date, osf_id)
  # consider adding step impute
prep(recipe) |>
  bake(new_data = NULL)

# customized recipe - lm, rf, knn
recipe2 <- recipe(birth_weight ~ ., data = pregnancy_train) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  # only remove unique ID
  step_rm(osf_id) |> 
  # add interaction term between threaten_baby_* survey
  step_interact(~ threaten_baby_danger:threaten_baby_harm) |> 
  # add interaction term between anxiety and depression levels
  step_interact(~ promis_anxiety:postnatal_depression) |> 
  # sqrt postnatal_depression for normality
  # -
  # specify delivery date as date
  step_date(delivery_date) 
prep(recipe2) |>
  bake(new_data = NULL)

# save recipes
save(recipe, recipe2, file = here("results/pregnancy_recipes.rda"))

