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
recipe <- recipe(birth_weight ~., data = pregnancy_train) |> 
  step_rm(osf_id, delivery_date, birth_length, language) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors()) 
prep(recipe) |>
  bake(new_data = NULL)

# save recipes
save(recipe, file = here("results/pregnancy_recipes.rda"))
