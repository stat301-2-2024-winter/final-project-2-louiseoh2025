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
            ridge_fit_folds |> collect_metrics() |> mutate(model = "ridge")) |> 
  relocate(model, .before = 1) 
metric_table |> knitr::kable()

# tuned models
best_rf <- show_best(rf_tuned, metric = "rmse")[1,]
select_best(rf_tuned, metric = "rmse")
best_bt <- show_best(bt_tuned, metric = "rmse")[1,]
select_best(bt_tuned, metric = "rmse")
best_knn <- show_best(knn_tuned, metric = "rmse")[1,]
select_best(knn_tuned, metric = "rmse")
best_rmse <- tibble(
  model = c("RF", "KNN", "BT"),
  RMSE = c(best_rf$mean, best_knn$mean, best_bt$mean),
  std_err = c(best_rf$std_err, best_knn$std_err, best_bt$std_err),
  n = c(best_rf$n, best_knn$n, best_bt$n)
)
best_rmse |> knitr::kable()

# RMSE table


# within 10% of the original price (similar to a confidence interval)
lm_percent <- pregnancy_test |> 
  bind_cols(predict(lm_fit, pregnancy_test)) |> 
  summarize(within_10_pct = mean((abs(.pred - birth_weight) / birth_weight) <= 0.1))
lm_percent |> knitr::kable()

lasso_percent <- pregnancy_test |> 
  bind_cols(predict(lm_fit, pregnancy_test)) |> 
  summarize(within_10_pct = mean((abs(.pred - birth_weight) / birth_weight) <= 0.1))
lasso_percent |> knitr::kable()
