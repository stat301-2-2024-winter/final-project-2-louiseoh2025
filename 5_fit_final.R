# Fit & analyze chosen final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# set seed for random process
set.seed(100)

# handle common conflicts
tidymodels_prefer()

# load testing data
load(here("results/pregnancy_split.rda"))

# load fits and recipes
load(here("results/fit_lm.rda"))
load(here("results/fit_lasso.rda"))
load(here("results/fit_ridge.rda"))
load(here("results/tuned_rf.rda"))
load(here("results/tuned_knn.rda"))
load(here("results/tuned_bt.rda"))
load(here("results/pregnancy_recipes.rda"))