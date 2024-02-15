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
ridge_spec <- linear_reg(penalty = 0.01, mixture = 0) |> 
  set_engine("glmnet") |> 
  set_mode("regression")

# define workflows ----
ridge_wf <- workflow() |> 
  add_model(ridge_spec) |> 
  add_recipe(recipe)

# fit workflows/models ----
ridge_fit <- fit(ridge_wf, pregnancy_train)
ridge_fit_folds <- fit_resamples(
  ridge_wf, resamples = pregnancy_folds,
  control = control_resamples(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(ridge_fit, ridge_fit_folds, file = here("results/fit_ridge.rda"))
