# Loading relevant library
library(tidyverse)
library(vtable)
library(tidylog)
library(lubridate)

# Load data from the College Scorecard Data Dictionary
CSDD <- read.csv("CollegeScorecardDataDictionary-09-08-2015.csv")

# Load Most Recent Cohorts Scorecard Elements Data
MRCSED <- read_csv("Most+Recent+Cohorts+(Scorecard+Elements).csv")

# Load ID Name Link Data
ID_NL <- read_csv("id_name_link.csv")

# Generate a list of files Load Google Trends Data total 12 files
Trends_FL <- list.files(path = "../kami/",
                        pattern = "trends_up_to_",
                        full.names = TRUE)

# Load Google trends data using the process file function 
Trends_df <- Trends_FL %>%
  map(read_csv) %>%
  bind_rows() %>%
  na.omit()

# Sorting data for MRCSED
MRCSED <- MRCSED %>%
  # Rename variables
  rename(unitid = UNITID, organization = INSTNM,
         grad_earning = `md_earn_wne_p10-REPORTED-EARNINGS`) %>%
  # Filter data and remove NULL
  filter(PREDDEG == 3, grad_earning != "PrivacySuppressed",
         grad_earning != "NULL") %>%
  # Data selection that is relevant
  mutate(grad_earning = as.numeric(grad_earning))
mean(MRCSED$grad_earning)

# Create dummy variable to separate high-earning colleges & low-earning colleges 
# based on the mean of graduates' wages ten years after graduation for organization.
MRCSED <- MRCSED %>%
  mutate(high_earning = case_when(grad_earning >= mean(grad_earning) ~ 1,
                                  grad_earning < mean(grad_earning) ~ 0))

# Merge data sets with inner_join by unitid
MRCSED <- inner_join(MRCSED, ID_NL, by = "unitid")

# Duplicates data for filter: removed 1,834 rows (98%), 28 rows remaining
Dups_MRCSED <- MRCSED %>%
  filter(schname %in% unique(.[["schname"]][duplicated(.[["schname"]])]))

# Remove those colleges that have the same exact name as another college
# filter: removed 28 rows (2%), 1,834 rows remaining
MRCSED <- MRCSED %>%
  filter(!(organization %in% Dups_MRCSED$organization))

# Merge data sets with left_join by schname
All_Data <- left_join(MRCSED, Trends_df, by = "schname")

# Filtered out NA in All_Data
All_Data <- All_Data %>%
  filter(index != "NA")

# Standardized index scores  
All_Data <- All_Data %>%
  # To calculate a standardized index, group by keyword and calculate the standardized index.
  group_by(organization, keyword)%>%
  mutate(index_std = (index - mean(index,na.rm = TRUE))/sd(index, na.rm = TRUE)) %>%
# summarise() 5,848 rows and 2 columns, one group variable remaining (organization)
  ungroup()
# Comprehensive college index by month
All_Data <- All_Data %>%
  # Split column into week start and week end
  separate(monthorweek, into = c("WSD", "WED"), 
           sep = " - ") %>%
  mutate(WSD = ymd(WSD)) %>%
  # Split column into year and month
  separate(WSD, into = c("year", "month"), 
           sep = "-", remove = FALSE) %>%
  # Numeric data type conversion
  mutate(year = as.numeric(year),
         month = as.numeric(month)) %>% 
  # Group by function 
  group_by(organization, year, month) %>%
  mutate(index_tot = mean(index_std)) %>%
  ungroup()

# Eliminate duplication and create unique identification.  
Final_Data <- All_Data %>%
  select(unitid, organization, grad_earning, year, month, index_tot, high_earning,
         WSD) %>%
  unite(col = "ID", c(unitid, year, month), sep = "-", remove = FALSE) %>%
  filter(!duplicated(ID))
# Create time variables
Final_Data <- Final_Data %>%
  mutate(time = as.character(WSD)) %>%
  mutate(time = time %>% str_replace_all("-","")) %>%
  mutate(time = time %>% str_sub(start = 1, end = 5)) %>%
  mutate(time = as.numeric(time)) %>%
  # arrange order by time
  arrange(time) %>%
  mutate(time_in = cumsum(c(1,as.numeric(diff(time)) != 0))) %>%
  select(-time) %>%
  rename(time = time_in) %>%
  mutate(time_v = time)
# Create dummy variable to separate the index before and after the September 2015
# publication of the college scorecard.
Final_Data <- Final_Data %>%
  mutate(College_Scorecard = case_when(year > 2015 ~ 1,
                                       year < 2015 ~ 0,
                                       year == 2015&month > 9 ~ 1,
                                       year == 2015&month <= 9 ~ 0))

College_Preparatory_Scorecard <- Final_Data %>%
  filter(College_Scorecard == 0)

College_Preparatory_Scorecard <- College_Preparatory_Scorecard %>%
  arrange(-time) %>%
  mutate(time_in = cumsum(c(1,as.numeric(diff(time)) != 0))) %>%
  mutate(time_in = time_in*-1) %>%
  select(-time) %>%
  rename(time = time_in)

College_Post_Scorecard <- Final_Data %>%
  filter(College_Scorecard == 1)
  
College_Post_Scorecard <- College_Post_Scorecard %>%
  arrange(time) %>%
  mutate(time_in = cumsum(c(1,as.numeric(diff(time)) != 0))) %>%
  select(-time) %>%
  rename(time = time_in)
  
Final_Data <- Final_Data %>%
  select(-ID, -WSD, -grad_earning, -year, -month)

# Write final data to file for the regression analysis
write_csv(Final_Data, "../kami/My_Cleaned_Data.csv")