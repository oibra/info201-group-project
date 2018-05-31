library(httr)
library(jsonlite)
library(dplyr)
library(tidyr)
library(ggplot2)
library(shiny)
library(maps)

source("apiKeys.R")

base_uri <- "https://api.usa.gov/crime/fbi/sapi/api/"

state_arson_data <- function(state_abbr, min_year, max_year) {
  url <- paste0(base_uri, "arson/states/", state_abbr, "?api_key=", oibraAPIKey)
  response <- GET(url)
  body <- content(response, "text")
  results <- fromJSON(body)
  results <- results$results
  
  results %>% 
    filter(year >= min_year, year <= max_year)
}

national_arson_data <- function() {
  url <- paste0(base_uri, "arson/national", "?api_key=", oibraAPIKey)
  response <- GET(url)
  body <- content(response, "text")
  results <- fromJSON(body)
  results$results
}

states <- state.name[state.name != "Virginia"]
