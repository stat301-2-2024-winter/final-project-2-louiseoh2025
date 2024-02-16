# Analysis of trained models (comparisons)
# Select final model

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

# collect metrics
metric_table <- lm_fit_folds |> collect_metrics() |> mutate(model = "lm") |> 
  bind_rows(lasso_fit_folds |> collect_metrics() |> mutate(model = "lasso"),
            ridge_fit_folds |> collect_metrics() |> mutate(model = "ridge"),
            rf_fit_folds |> collect_metrics() |> mutate(model = "rf")) |> 
  relocate(model, .before = 1)
metric_table |> knitr::kable()

# within 10% of the original price (similar to a confidence interval)
lm_percent <- pregnancy_test |> 
  bind_cols(predict(lm_fit, pregnancy_test)) |> 
  summarize(within_10_pct = mean((abs(.pred - birth_weight) / birth_weight) <= 0.1))
lm_percent |> knitr::kable()

lasso_percent <- pregnancy_test |> 
  bind_cols(predict(lm_fit, pregnancy_test)) |> 
  summarize(within_10_pct = mean((abs(.pred - birth_weight) / birth_weight) <= 0.1))
lasso_percent |> knitr::kable()
