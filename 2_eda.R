# EDA for RECIPES

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# set seed for random process
set.seed(100)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("results/pregnancy_split.rda"))

# glimpse data
glimpse(pregnancy_train)

# univariate
vars <- pregnancy_train |> 
  colnames()
for (var in vars) {
  if (is.numeric(pregnancy_train[[var]])) {
    # create histogram for the current numerical variable
    hist <- ggplot(pregnancy_train, aes(x = !!as.name(var))) +
      geom_histogram() +
      theme_minimal()
    print(hist)
  } else {
    # create bar plot for non-numeric variables
    bar <- ggplot(pregnancy_train, aes(x = !!as.name(var))) +
      geom_bar() +
      theme_minimal()
    print(bar)
  }
}

## postnatal_depression scaling
ggplot(pregnancy_train, aes(x = (postnatal_depression))) +
  geom_histogram() +
  theme_minimal()

# correlation plot
corr <- pregnancy_train |> 
  select(where(is.numeric)) |> 
  cor()
ggcorrplot::ggcorrplot(corr, 
                       type = "lower",
                       lab = TRUE, 
                       method = "square")
## promis_anxiety and postnatal_depression = .8
## threaten_baby_danger and threaten_baby_harm = .73

