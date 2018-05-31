library("shiny")
library("dplyr")

arrests <- read.csv("arrests_national.csv", stringsAsFactors = FALSE)

arrests_percentage <- transform(arrests, Homicides = homicide / total_arrests)



latest_year <- arrests %>%
  filter(year == 2016) %>%
  mutate(round((homicide / total_arrests) * 100)) %>%
  mutate(round(rape / total_arrests) * 100)
  mutate(round(violent_crime / total_arrests * 100 ))
percentage_homicide <- latest_year %>%
  mutate(round((homicide / total_arrests) * 100)) %>%
  

percentage_rape <- latest_year %>%
  mutate(round(rape / total_arrests) * 100)

percentage_violent_crime <- latest_year %>% 
  mutate(round(violent_crime / total_arrests * 100 ))

percentage_property_crime <- latest_year %>%
  mutate(round(property_crime / total_arrests) * 100 )

percentage_robberies <- latest_year %>%
  mutate(round(robbery / total_arrests) * 100)

percentage_assaults <- latest_year %>%
  mutate(round(percentage_assaults / total_arrests) * 100)

percent_burglaries <- latest_year %>%
  mutate(round(burglary / total_arrests) * 100)

percentage_larceny <- latest_year %>%
  mutate(round(larceny / total_arrests) * 100)

percentage_mvt <- latest_year %>%
  mutate(round(motor_vehicle_theft / total_arrests) * 100)
