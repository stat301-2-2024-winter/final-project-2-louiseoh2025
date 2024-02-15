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

# standard recipe
recipe <- recipe(birth_weight ~ ., data = pregnancy_train) |> 
  # filter out variables have have zero variance
  step_zv(all_predictors()) |> 
  # center and scale all predictors
  step_normalize(all_numeric_predictors()) |> 
  # one-hot encode all categorical predictors
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_rm(delivery_date)
prep(recipe) |>
  bake(new_data = NULL)

# customized recipe


# save recipes
save(recipe, file = here("results/pregnancy_recipes.rda"))
