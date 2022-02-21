# ECON 4110 22WQ - Data Exploration Assignment

Author: Yinhui(Kami) Yang

## Introduction of the Data

In this project we will be compiling together some messy real-world data, and then designing an analysis to answer a research question. 

Regarding this project, we will analyze total fifteen datasets (Datasets: trends_up_to_....csv whcih included twelve files, Most+Recent+Cohorts+(Scorecard+Elements).csv, CollegeScorecardDataDictionary-09-08-2015.csv, id_name_link.csv) The data set used in this analysis is composed of information from the college scorecard and all Google trend data files. The trend index of each organization is standardized and examined on a monthly and college-level using Google data. From the data file of the college scorecard, I mainly used the organization that awarded the bachelor's degree and a variable that distinguished the high-income and low-income colleges as the average of all the median incomes of students in 10 years after graduation, which was about 42,116.98 US dollars. The rationale for using the mean amount instead of the median value is that when calculating this variable takes into consideration all of the median income in the colleges' calculation, and I believe that this is the best metric to distinguish between high-income and low-income.

According to the Google trend data file, I utilized the dates connected to university terms, Google search, and the indexes they gave from the Google trend data file at first. The average value is removed from each keyword group's index and divided by the index's standard deviation, resulting in a standardization of the index values. Second, I computed the total of standardized indexes using the average value of each college's monthly standardized index, and finally located the variable "index tot" in the data set. Finally, to generate the binary "College Scorecard" variable, I assigned 1 to all data rows linked to the time period after September 2015, and 0 to all data rows connected to the time period during or before the September 2015 release of the College Scorecard.

The data gathered from March 31, 2013, to March 26, 2016, is included in the outcome data set utilized in this research. I constructed two dummy variables to indicate the income of high-income and low-income college graduate students, using the comprehensive index data of 1785 from organizations and the time variable. Lastly, data preparatory and post the college scorecard indicate data before and after the university scorecard is published.

## The Analysis

The College Scorecard isn’t just data for us - it’s also treatment! The College Scorecard is a public-facing website that contains important information about colleges, including how much its graduates earn. This information has traditionally been very difficult to find.

###### RESEARCH QUESTION:

The College Scorecard was released at the start of September 2015. Among colleges that predominantly grant bachelor’s degrees, did the release of the Scorecard shift student interest to high-earnings colleges relative to low-earnings ones (as proxied by Google searches for keywords associated with those colleges)?

The major regression Model1 that will be investigated in order to address this research question examines the effect of the College Scorecard's public publication on public interest in high-earning organizations vs low-earning organizations, as well as assessed by Google searches for college-related keywords. To begin with, it returns the influence of high-income colleges relative to low-income colleges based on Google searches for keywords related to these colleges, and the interactive influence is based on the relationship between the publication of college scorecard and how students' interest in high-income colleges compares to low-income colleges, so the model includes the interaction between college scorecard and high-income colleges. Second, because the effects of college scorecard is dependent on the level of time variables, the model includes the interaction between time and college scorecard variables. These variables are interdependent and must be included in the model.

# Model 1

![Result Image](Model.png)




## Conclusion












