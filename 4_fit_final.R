# Fit & analyze chosen final model

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

# fit final model to whole training dataset -----
# finalize workflow 
final_wf <- rf_tuned2 |> 
  extract_workflow() |>  
  finalize_workflow(select_best(rf_tuned2, metric = "rmse"))
# train final model 
final_fit <- fit(final_wf, pregnancy_train)
# save final fit
save(final_fit, final_wf, file = here("results/final_fit.rda"))

# final prediction -----
final_pred <- pregnancy_test |> 
  bind_cols(predict(final_fit, pregnancy_test)) |> 
  select(birth_weight, .pred)

# final metrics -----
final_metrics <- metric_set(rmse, mae, rsq)
final_table <- tibble(
  metric = c("RMSE", "MAE", "RSQ"),
  RandomForest = final_metrics(final_pred, truth = birth_weight, estimate = .pred) |> 
    pull(.estimate)
)
final_table |> 
  kable()

# within 10% interval -----
final_percent <- pregnancy_test |> 
    bind_cols(predict(final_fit, pregnancy_test)) |>
    summarize(within_10_pct = mean((abs(.pred - birth_weight) / birth_weight) <= 0.1))
final_percent |> 
  kable()

# plot actual vs. pred -----
final_plot <- pregnancy_test |>
  select(birth_weight) |>
  bind_cols(predict(final_fit, pregnancy_test)) |>
  ggplot(aes(x = birth_weight, y = .pred)) +
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.4) + 
  theme_minimal() +
  labs(title = "Baby's Actual vs. Predicted Birth Weight",
       x = "Birth Weight (g)", 
       y = "Predicted Birth Weight (g)") +
  coord_obs_pred()


# save final tables and plots
save(final_table, final_percent, final_plot, file = here("results/final_results.rda"))
