## Overview

This project aims to properly develop a predictive model using supervised learning methods. It will identify and develop a predictive research question/objective for the Mental Health In Pregnancy During COVID-19^[Mental Health In Pregnancy During COVID-19 --- [https://www.kaggle.com/datasets/yeganehbavafa/mental-health-in-the-pregnancy-during-the-covid-19](https://www.kaggle.com/datasets/yeganehbavafa/mental-health-in-the-pregnancy-during-the-covid-19)], then properly apply machine/statistical learning methods to address it.

## Folders

- `data/`: contains all datasets used for the final report

- `memos/`: contains all progress memos that lead to the final project

## R Scripts

- `0_data_cleaning.R`: codes used to clean and save data ready for use

- `1_initial_setup.R`: codes used to split and fold data

- `2_eda.R`: codes used for eda of training data to create customized recipes

- `2_recipes.R`: codes used to create two recipes used for fitting the models

- `3_fit_lm.R`: codes used to specify and fit/resample the baseline/linear regression model

- `3_fit_lasso.R`: codes used to specify and fit/tune the lasso regression model

- `3_fit_ridge.R`: codes used to specify and fit/tune the ridge regression model

- `3_fit_rf.R`: codes used to specify and fit/tune the random forest model

- `3_fit_knn.R`: codes used to specify and fit/tune the k-nearest neighbor model

- `3_fit_bt.R`: codes used to specify and fit/tune the boosted tree model

- `4_model_analysis.R`: codes used to analyze which model works best

- `4_fit_final.R`: codes used to fit and asses the final model chosen for the prediction project

## Reports

- `Oh_Louise_final_report.qmd`: quarto markdown document to create the final report

- `Oh_Louise_final_report.html`: the final report

- `Oh_Louise_executive_summary.qmd`: quarto markdown document to create the executive summary

- `Oh_Louise_executive_summary.html`: the executive summary

