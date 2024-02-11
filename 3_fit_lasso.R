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
load(here("results/pregnancy_folds.rda"))

# model specifications ----
lasso_spec <- linear_reg(penalty = 0.01, mixture = 1) |> 
  set_engine("glmnet") |> 
  set_mode("regression")

# define workflows ----
lasso_wf <- workflow() |> 
  add_model(lasso_spec) |> 
  add_recipe(recipe)

# fit workflows/models ----
lasso_fit <- fit(lasso_wf, pregnancy_train)
lasso_fit_folds <- fit_resamples(
  lasso_wf, resamples = pregnancy_folds,
  control = control_resamples(save_workflow = TRUE,
                              parallel_over = "everything")
  )

# write out results (fitted/trained workflows) ----
save(lasso_fit, lasso_fit_folds, file = here("results/fit_lasso.rda"))
