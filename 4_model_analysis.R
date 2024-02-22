# Analysis of trained models (comparisons)
# Select final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(tune)
library(parsnip)
library(knitr)

# set seed for random process
set.seed(100)

# handle common conflicts
tidymodels_prefer()

# load testing data
load(here("results/pregnancy_split.rda"))

# load fits and recipes
load(here("results/fit_lm.rda"))
load(here("results/tuned_lasso.rda"))
load(here("results/tuned_ridge.rda"))
load(here("results/tuned_knn.rda"))
load(here("results/tuned_bt.rda"))
load(here("results/tuned_rf.rda"))
load(here("results/pregnancy_recipes.rda"))

# autoplots -----

# lasso
autoplot(lasso_tuned, metric = "rmse") + 
  theme_minimal() +
  ggtitle("Lasso Regression Model (kitchen sink)")
autoplot(lasso_tuned2, metric = "rmse") + 
  theme_minimal() +
  ggtitle("Lasso Regression Model (customized)")
# ridge
autoplot(ridge_tuned, metric = "rmse") + 
  theme_minimal() +
  ggtitle("Ridge Regression Model (kitchen sink)")
autoplot(ridge_tuned2, metric = "rmse") + 
  theme_minimal() +
  ggtitle("Ridge Regression Model (customized)")
# knn
autoplot(knn_tuned, metric = "rmse") + 
  theme_minimal() +
  ggtitle("K-Nearest Neighbor Model (kitchen sink)")
autoplot(knn_tuned2, metric = "rmse") + 
  theme_minimal() +
  ggtitle("K-Nearest Neighbor Model (customized)")
# bt
autoplot(bt_tuned, metric = "rmse") + 
  theme_minimal() +
  ggtitle("Boosted Tree Model (kitchen sink)")
autoplot(bt_tuned2, metric = "rmse") + 
  theme_minimal() +
  ggtitle("Boosted Tree Model (customized)")
# rf
autoplot(rf_tuned, metric = "rmse") + 
  theme_minimal() +
  ggtitle("Random Forest Model (kitchen sink)")
autoplot(rf_tuned2, metric = "rmse") + 
  theme_minimal() +
  ggtitle("Random Forest Model (customized)")

# tuned models -----
select_best(lasso_tuned, metric = "rmse")
select_best(lasso_tuned2, metric = "rmse")
select_best(ridge_tuned, metric = "rmse")
select_best(ridge_tuned2, metric = "rmse")
select_best(knn_tuned, metric = "rmse") 
select_best(knn_tuned2, metric = "rmse") 
select_best(bt_tuned, metric = "rmse") 
select_best(bt_tuned2, metric = "rmse") 
select_best(rf_tuned, metric = "rmse") 
select_best(rf_tuned2, metric = "rmse") 

# RMSE table -----
tbl_lm <- lm_fit |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Linear Regression",
         recipe = "kitchen sink")
tbl_lm2 <- lm_fit2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Linear Regression",
         recipe = "customized")
tbl_lasso <- lasso_tuned |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Lasso Regression",
         recipe = "kitchen sink")
tbl_lasso2 <- lasso_tuned2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Lasso Regression",
         recipe = "customized")
tbl_ridge <- ridge_tuned |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Ridge Regression",
         recipe = "kitchen sink")
tbl_ridge2 <- ridge_tuned2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Ridge Regression",
         recipe = "customized")
tbl_knn <- knn_tuned |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "K Nearest Neighbor",
         recipe = "kitchen sink")
tbl_knn2 <- knn_tuned2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "K Nearest Neighbor",
         recipe = "customized")
tbl_bt <- bt_tuned |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Boosted Tree",
         recipe = "kitchen sink")
tbl_bt2 <- bt_tuned2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Boosted Tree",
         recipe = "customized")
tbl_rf <- rf_tuned |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Random Forest",
         recipe = "kitchen sink")
tbl_rf2 <- rf_tuned2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Random Forest",
         recipe = "customized")
bind_rows(tbl_lm, tbl_lm2,
          tbl_lasso, tbl_lasso2,
          tbl_ridge, tbl_ridge2,
          tbl_knn, tbl_knn2,
          tbl_bt, tbl_bt2,
          tbl_rf, tbl_rf2)|> 
  distinct(model, recipe, .keep_all = TRUE) |> 
  select(model, recipe, everything()) |> 
  kable()

# save rmse tables
save(tbl_lm, tbl_lm2,
     tbl_lasso, tbl_lasso2,
     tbl_ridge, tbl_ridge2,
     tbl_knn, tbl_knn2,
     tbl_bt, tbl_bt2,
     tbl_rf, tbl_rf2,
     file = here("results/analysis_rmse.rda"))

