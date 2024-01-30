# DATA CLEANING

# load library
library(tidyverse)

# load data
brain <- read_csv("data/brain_tumor.csv") |> 
  janitor::clean_names()

# skim data
glimpse(brain)

# variable types
brain <- brain |>
  mutate(class = factor(class))

# skim data
glimpse(brain)
