# DATA CLEANING

# load library
library(tidyverse)
library(lubridate)

# load data
# https://www.kaggle.com/datasets/yeganehbavafa/mental-health-in-the-pregnancy-during-the-covid-19
pregnancy <- read_csv("data/pregnancy.csv") |> 
  janitor::clean_names()

# glimpse data
glimpse(pregnancy)

# filter all rows with missing values
for(col in names(pregnancy)) {
  pregnancy <- pregnancy[!is.na(pregnancy[[col]]), ]
}

# rename variables
pregnancy <- pregnancy |> 
  rename(postnatal_depression = edinburgh_postnatal_depression_scale,
         delivery_date = delivery_date_converted_to_month_and_year)

# change variable types
for (col in names(pregnancy)) {
  if (col != "delivery_date" && is.character(pregnancy[[col]])) {
    pregnancy[[col]] <- factor(pregnancy[[col]])
  }
}

# change date format
pregnancy <- pregnancy |>  
  mutate(delivery_date = dmy(paste("01", delivery_date)))

# glimpse data
glimpse(pregnancy)

