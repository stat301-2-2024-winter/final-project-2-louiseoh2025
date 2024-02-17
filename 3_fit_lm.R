# Define and fit linear regression

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

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
lm_spec <- linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wf <- workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(recipe)
lm_wf2 <- workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(recipe2)

# fit workflows/models ----
lm_fit <- fit(lm_wf, pregnancy_train)
lm_fit_folds <- fit_resamples(
  lm_wf2, resamples = pregnancy_folds,
  control = control_resamples(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(lm_fit, lm_fit_folds, file = here("results/fit_lm.rda"))
