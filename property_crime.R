library(tidyr)
library(ggplot2)
library(shiny)
library(maps)
library(httr)
library(jsonlite)
library(dplyr)


source("apiKeys.R")

base_uri <- "https://api.usa.gov/crime/fbi/sapi/api/"

state_property_crime_data <- function(state_abbr) {
  url <- paste0(base_uri, "arson/states/", state_abbr, "?api_key=", apiKey)
  response <- GET(url)
  body <- content(response, "text")
  results <- fromJSON(body)
  results$results
}

national_property_crime_data <- function() {
  url <- paste0(base_uri, "allpropertycrime/national", "?api_key=", apiKey)
  response <- GET(url)
  body <- content(response, "text")
  results <- fromJSON(body)
  results$results
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("state", "State: ", choices = append(state.name, "National", 26), 
                  selected = "National"),
      
      br(),
      
      checkboxGroupInput("choices", "Plot: ", 
                         c("Reported Cases" = "reported", 
                           "Verified Cases" = "verified", 
                         selected = "confirmed"),
      
      br()#,
      
      # sliderInput("years", "Years", , c(2000, 2016), min = 2000, max = 2016, ) 
    ),
    
    mainPanel(
      plotOutput("plot")
      )
    )
  )
)

