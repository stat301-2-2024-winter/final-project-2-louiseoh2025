# Define and fit null/baseline model

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

## NULL MODEL ----

# model specification
null_spec <- null_model() |> 
  set_engine("parsnip") |> 
  set_mode("regression") 
# define workflow
null_workflow <- workflow() |> 
  add_model(null_spec) |> 
  add_recipe(recipe1)
# fit workflow/model
null_fit <- null_workflow |> 
  fit_resamples(
    resamples = pregnancy_folds, 
    control = control_resamples(save_workflow = TRUE)
  )



# write out results (fitted/trained workflows) ----
save(null_fit, file = here("results/fit_null.rda"))
