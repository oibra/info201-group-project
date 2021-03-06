# Name: Jeni Lane
# Group AC6 - Team Red
# Date: 05/29/2018
# Info 201 A Spring 2018
# TA: Anukriti Goyal (Section AC)

library("dplyr")
library("ggplot2")

crime_data <- read.csv("data/estimated_crimes.csv", stringsAsFactors = FALSE)

summary_data <- filter(crime_data, state_abbr == "") %>% 
  select(-population, -state_abbr)

states_only <- crime_data %>% 
  filter(state_abbr != "")

states_2016 <- states_only %>% 
  filter(year == 2016)

biggest_crime <- "property_crime"

state_prop_crime_max <- crime_data %>% 
  group_by(year) %>% 
  filter(state_abbr != "") %>% 
  filter(property_crime == max(property_crime)) 
# Max: California

state_prop_crime_min <- crime_data %>% 
  group_by(year) %>% 
  filter(state_abbr != "") %>% 
  filter(property_crime == min(property_crime)) 
# Min: Vermont in 2016, Wyoming for 2011-2013, and North Dakota before

state_name <- "California"

#California data
cal_data_recent <- crime_data %>% 
  filter(year == max(year) & state_abbr == "CA")

cal_population <- cal_data_recent %>% 
  select(population)

cal_population <- formatC(as.numeric(cal_population), format = "f", big.mark = ",", digits = 0)

cal_total_crime <- cal_data_recent %>% 
  select(-year, -state_abbr, -population)

cal_total_crime <- sum(cal_total_crime)

cal_property <- cal_data_recent %>% 
  select(property_crime)

cal_percentage <- round(as.numeric(cal_property) / cal_total_crime * 100, 0)

#Vermont data
ver_data_recent <- crime_data %>% 
  filter(year == max(year) & state_abbr == "VT")

ver_total_crime <- ver_data_recent %>% 
  select(-year, -state_abbr, -population)

ver_total_crime <- sum(ver_total_crime)

ver_property <- ver_data_recent %>% 
  select(property_crime)

vermont_percentage <- round(as.numeric(ver_property) / ver_total_crime * 100, 0)

#Seattle Data
wa_data_recent <- crime_data %>% 
  filter(year == max(year) & state_abbr == "WA")

wa_total_crime <- wa_data_recent %>% 
  select(-year, -state_abbr, -population)

wa_total_crime <- sum(wa_total_crime)

wa_property <- wa_data_recent %>% 
  select(property_crime)

wash_percentage <- round(as.numeric(wa_property) / wa_total_crime * 100, 0)

cali_wash_range <- wash_percentage - cal_percentage

cali_vermont_range <- vermont_percentage - cal_percentage

#Mean percentage of property crime
property_percents <- crime_data %>% 
  filter(year == 2016 & state_abbr != "") %>% 
  select(-year, -state_abbr, -population)
    
property_percents$total_crime <- rowSums(property_percents) 

property_percents$prop_percent <- round(property_percents$property_crime / 
                                          property_percents$total_crime * 100, 0)

mean_percentage <- round(mean(property_percents$prop_percent), 0)

min_percentage <- min(property_percents$prop_percent)

max_percentage <- max(property_percents$prop_percent)
