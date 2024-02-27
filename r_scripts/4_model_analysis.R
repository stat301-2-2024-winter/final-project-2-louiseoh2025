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
load(here("data_splits/pregnancy_split.rda"))

# load fits and recipes
load(here("results/fit_null.rda"))
load(here("results/fit_lm.rda"))
load(here("results/tuned_lasso.rda"))
load(here("results/tuned_ridge.rda"))
load(here("results/tuned_knn.rda"))
load(here("results/tuned_bt.rda"))
load(here("results/tuned_rf.rda"))
load(here("recipes/pregnancy_recipes.rda"))

## AUTOPLOT -----

# lasso
autoplot(lasso_tuned1, metric = "rmse") + 
  theme_minimal() +
  labs(title = "Lasso Regression Model",
       subtitle = "recipe 1 (parametric)")
autoplot(lasso_tuned2, metric = "rmse") + 
  theme_minimal() +
  labs(title = "Lasso Regression Model",
       subtitle = "recipe 2 (parametric)")
# ridge
autoplot(ridge_tuned1, metric = "rmse") + 
  theme_minimal()  +
  labs(title = "Ridge Regression Model",
       subtitle = "recipe 1 (parametric)")
autoplot(ridge_tuned2, metric = "rmse") + 
  theme_minimal()  +
  labs(title = "Ridge Regression Model",
       subtitle = "recipe 1 (parametric)")
# knn
autoplot(knn_tuned1, metric = "rmse") + 
  theme_minimal() +
  labs(title = "K Nearest Neighbor Model",
       subtitle = "recipe 1 (tree)")
autoplot(knn_tuned2, metric = "rmse") + 
  theme_minimal() +
  labs(title = "K Nearest Neighbor Model",
       subtitle = "recipe 2 (tree)")
# bt
autoplot(bt_tuned1, metric = "rmse") + 
  theme_minimal() +
  labs(title = "Boosted Tree Model",
       subtitle = "recipe 1 (tree)")
autoplot(bt_tuned2, metric = "rmse") + 
  theme_minimal() +
  labs(title = "Boosted Tree Model",
       subtitle = "recipe 2 (tree)")
# rf
autoplot(rf_tuned1, metric = "rmse") + 
  theme_minimal() +
  labs(title = "Random Forest Model",
       subtitle = "recipe 1 (tree)")
autoplot(rf_tuned2, metric = "rmse") + 
  theme_minimal() +
  labs(title = "Random Forest Model",
       subtitle = "recipe 2 (tree)")

## TUNED MODEL PARAMETERS -----
lasso1_best <- select_best(lasso_tuned1, metric = "rmse") |> 
  mutate(recipe = "recipe 1 (parametric)")
lasso2_best <- select_best(lasso_tuned2, metric = "rmse") |> 
  mutate(recipe = "recipe 2 (parametric)")
lasso_best <- bind_rows(lasso1_best, lasso2_best) |> 
  select(recipe, everything()) |> 
  kable(caption = "Lasso Regression")
lasso_best
ridge1_best <- select_best(ridge_tuned1, metric = "rmse") |> 
  mutate(recipe = "recipe 1 (parametric)")
ridge2_best <- select_best(ridge_tuned2, metric = "rmse") |> 
  mutate(recipe = "recipe 2 (parametric)")
ridge_best <- bind_rows(ridge1_best, ridge2_best) |> 
  select(recipe, everything()) |> 
  kable(caption = "Ridge Regression")
ridge_best
knn1_best <- select_best(knn_tuned1, metric = "rmse") |> 
  mutate(recipe = "recipe 1 (tree)")
knn2_best <- select_best(knn_tuned2, metric = "rmse") |> 
  mutate(recipe = "recipe 2 (tree)")
knn_best <- bind_rows(knn1_best, knn2_best) |> 
  select(recipe, everything()) |> 
  kable(caption = "K Nearest Neighbor")
knn_best
bt1_best <- select_best(bt_tuned1, metric = "rmse") |> 
  mutate(recipe = "recipe 1 (tree)")
bt2_best <- select_best(bt_tuned2, metric = "rmse") |> 
  mutate(recipe = "recipe 2 (tree)")
bt_best <- bind_rows(bt1_best, bt2_best) |> 
  select(recipe, everything()) |> 
  kable(caption = "Boosted Tree")
bt_best
rf1_best <- select_best(rf_tuned1, metric = "rmse") |> 
  mutate(recipe = "recipe 1 (tree)")
rf2_best <- select_best(rf_tuned2, metric = "rmse") |> 
  mutate(recipe = "recipe 2 (tree)")
rf_best <- bind_rows(rf1_best, rf2_best) |> 
  select(recipe, everything()) |> 
  kable(caption = "Random Forest")
rf_best

# save model para tables
save(lasso_best, ridge_best, knn_best, bt_best, rf_best,
     file = here("analysis/model_analysis_parameters.rda"))

## RMSE -----

tbl_null <- null_fit |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Null",
         recipe = "recipe 1 (parametric)")
tbl_lm1 <- lm_fit1 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Linear Regression",
         recipe = "recipe 1 (parametric)")
tbl_lm2 <- lm_fit2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Linear Regression",
         recipe = "recipe 2 (parametric)")
tbl_lasso1 <- lasso_tuned1 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Lasso Regression",
         recipe = "recipe 1 (parametric)")
tbl_lasso2 <- lasso_tuned2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Lasso Regression",
         recipe = "recipe 2 (parametric)")
tbl_ridge1 <- ridge_tuned1 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Ridge Regression",
         recipe = "recipe 1 (parametric)")
tbl_ridge2 <- ridge_tuned2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Ridge Regression",
         recipe = "recipe 2 (parametric)")
tbl_knn1 <- knn_tuned1 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "K Nearest Neighbor",
         recipe = "recipe 1 (tree)")
tbl_knn2 <- knn_tuned2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "K Nearest Neighbor",
         recipe = "recipe 2 (tree)")
tbl_bt1 <- bt_tuned1 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Boosted Tree",
         recipe = "recipe 1 (tree)")
tbl_bt2 <- bt_tuned2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Boosted Tree",
         recipe = "recipe 2 (tree)")
tbl_rf1 <- rf_tuned1 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Random Forest",
         recipe = "recipe 1 (tree)")
tbl_rf2 <- rf_tuned2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Random Forest",
         recipe = "recipe 2 (tree)")
tbl_rmse <- bind_rows(tbl_null, 
                      tbl_lm1, tbl_lm2,
                      tbl_lasso1, tbl_lasso2,
                      tbl_ridge1, tbl_ridge2,
                      tbl_knn1, tbl_knn2,
                      tbl_bt1, tbl_bt2,
                      tbl_rf1, tbl_rf2) |> 
  distinct(model, recipe, .keep_all = TRUE) |> 
  select(model, recipe, everything()) |> 
  kable()
tbl_rmse

# save rmse table
save(tbl_rmse, file = here("analysis/model_analysis_rmse.rda"))

