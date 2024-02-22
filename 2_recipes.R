# RECIPES

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(recipes)

# set seed for random process
set.seed(100)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("results/pregnancy_split.rda"))


## RECIPE kitchen sink for baseline -----
recipe_baseline <- recipe(birth_weight ~ ., data = pregnancy_train) |> 
  # remove uniqueID and delivery_date
  step_rm(osf_id, delivery_date) |> 
  # add dummy variable to all categorical predictors
  step_dummy(all_nominal_predictors()) |> 
  # filter out variables have have zero variance
  step_zv(all_predictors()) |> 
  # center and scale all predictors
  step_normalize(all_numeric_predictors())
prep(recipe_np) |>
  bake(new_data = NULL)

## RECIPE 1 for non parametric -----
recipe1_np <- recipe(birth_weight ~ ., data = pregnancy_train) |> 
  step_rm(osf_id, delivery_date) |> 
  # impute missing numerical variables using knn 
  step_impute_knn(maternal_age, postnatal_depression, promis_anxiety, gestational_age, 
                  birth_length, threaten_life, threaten_baby_danger, threaten_baby_harm,
                  household_income, maternal_education, delivery_mode, nicu_stay,
                  delivery_month, delivery_year) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())
prep(recipe1_np) |>
  bake(new_data = NULL)

## RECIPE 1 for trees -----
recipe1_tree <- recipe(birth_weight ~ ., data = pregnancy_train) |> 
  step_rm(osf_id, delivery_date) |> 
  step_impute_knn(maternal_age, postnatal_depression, promis_anxiety, gestational_age, 
                  birth_length, threaten_life, threaten_baby_danger, threaten_baby_harm,
                  household_income, maternal_education, delivery_mode, nicu_stay,
                  delivery_month, delivery_year) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())
prep(recipe1_tree) |>
  bake(new_data = NULL)

## RECIPE 2 for non parametric -----
recipe2_np <- recipe(birth_weight ~ ., data = pregnancy_train) |> 
  step_rm(osf_id, delivery_date) |> 
  step_impute_knn(maternal_age, postnatal_depression, promis_anxiety, gestational_age, 
                  birth_length, threaten_life, threaten_baby_danger, threaten_baby_harm,
                  household_income, maternal_education, delivery_mode, nicu_stay,
                  delivery_month, delivery_year) |> 
  # sqrt postnatal_depression for normality
  step_sqrt(postnatal_depression) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) |> 
  # add interaction term between threaten_baby_* survey
  step_interact(~ threaten_baby_danger:threaten_baby_harm) |> 
  # add interaction term between anxiety and depression levels
  step_interact(~ promis_anxiety:postnatal_depression) 
prep(recipe2_np) |>
  bake(new_data = NULL)

## RECIPE 2 for trees -----
recipe2_tree <- recipe(birth_weight ~ ., data = pregnancy_train) |> 
  step_rm(osf_id, delivery_date) |> 
  step_impute_knn(maternal_age, postnatal_depression, promis_anxiety, gestational_age, 
                  birth_length, threaten_life, threaten_baby_danger, threaten_baby_harm,
                  household_income, maternal_education, delivery_mode, nicu_stay,
                  delivery_month, delivery_year) |> 
  # sqrt postnatal_depression for normality
  step_sqrt(postnatal_depression) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())
prep(recipe2_tree) |>
  bake(new_data = NULL)

# save recipes
save(recipe_baseline, 
     recipe1_np, recipe1_tree, 
     recipe2_np, recipe2_tree, 
     file = here("results/pregnancy_recipes.rda"))

