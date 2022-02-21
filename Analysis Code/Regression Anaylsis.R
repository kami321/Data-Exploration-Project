# Load relevant libraries
library(tidyverse)
library(vtable)
library(jtools)
library(car)

My_Cleaned_Data <- read_csv("../kami/My_Cleaned_Data.csv")

# Look up data at vtable
vtable(My_Cleaned_Data) 

My_Cleaned_Data <- My_Cleaned_Data %>%
  mutate(organization = factor(organization))

# Regression model 1
Model1 <- lm(formula = index_tot ~ College_Scorecard + high_earning + time_v + College_Scorecard*time_v + College_Scorecard*high_earning, data = My_Cleaned_Data)
export_summs(Model1, digits = 3, robust = TRUE)

# Hypothesis test: if the effect of College_Scorecard on index scores is 0
linearHypothesis(Model1, "College_Scorecard = 0", white.adjust = TRUE)

# Organization, filter: removed 63,500 rows (97%), 1,785 rows remaining
organization <- My_Cleaned_Data %>% 
  filter(!duplicated(organization)) %>%
  summarize()

# Summary Statistics for comprehensive index and time
summary(My_Cleaned_Data[c("index_tot", "time_v")]) 

# Standard Deviation [1] 0.5791552
sd(My_Cleaned_Data$index_tot)

# Correlation between College_Scorecard, high_earning, time_v
cor(My_Cleaned_Data[c("College_Scorecard", "high_earning", "time_v")])

# Histogram plots for My Cleaned Data and College Scorecard
hist(My_Cleaned_Data$College_Scorecard)

# Regression results: differences between high-earning and low-earning college graduates
ggplot(data = My_Cleaned_Data, aes(x = College_Scorecard, y = index_tot,
                                   group= high_earning, color=factor(high_earning))) + 
  geom_line() + 
  xlab("College Scorecard") + 
  ylab("Comprehensive Index") + 
  scale_color_discrete(name = "high_earning", labels = c("Low Earning", "High Earning"))