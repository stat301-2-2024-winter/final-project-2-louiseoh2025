# Define and fit random forest

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
load(here("results/pregnancy_folds.rda"))

# model specifications ----
rf_spec <- rand_forest(trees = 600, min_n = 10) |> 
  set_engine("ranger") |> 
  set_mode("regression")

# define workflows ----
rf_wf<- workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(recipe)

# fit workflows/models ----
rf_fit <- fit(rf_wf, pregnancy_train)
rf_fit_folds <- fit_resamples(
  rf_wf, resamples = pregnancy_folds,
  control = control_resamples(save_workflow = TRUE,
                              parallel_over = "everything")
  )

# write out results (fitted/trained workflows) ----
save(rf_fit, rf_fit_folds, file = here("results/fit_rf.rda"))
