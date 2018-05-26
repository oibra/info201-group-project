library(httr)
library(jsonlite)
library(dplyr)
library(tidyr)
library(ggplot2)
library(shiny)
library(maps)

source("apiKeys.R")

base_uri <- "https://api.usa.gov/crime/fbi/sapi/api/"

state_arson_data <- function(state_abbr) {
  url <- paste0(base_uri, "arson/states/", state_abbr, "?api_key=", oibraAPIKey)
  response <- GET(url)
  body <- content(response, "text")
  results <- fromJSON(body)
  results$results
}

national_arson_data <- function() {
  url <- paste0(base_uri, "arson/national", "?api_key=", oibraAPIKey)
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
                           "Confirmed Cases" = "confirmed", 
                           "Damage Value ($)" = "damage"),
                         selected = "confirmed"),
      
      br()#,
      
      # sliderInput("years", "Years", , c(1979, 2016), min = 1979, max = 2016)
    ),
    
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output) {
  output$plot <- renderPlot({
    arson_data <- ""
    if (input$state == "National") {
      arson_data <- national_arson_data()
      
      plot <- ggplot(data = arson_data)
      
      if (input$reported) {
        plot <- plot + geom_line(mapping = aes(x = year, y = reported), color = "blue")
      }
      
      if (input$confirmed) {
        plot <- plot + geom_line(mapping = aes(x = year, y = actual), color = "red")
      }
      
      if (input$damage) {
        plot <- plot + geom_line(mapping = aes(x = year, y = est_damage_value))
      }
      
      plot
    } else {
      state <- state.abb[grep(input$state, state.name)]
      arson_data <- state_arson_data(state)
      
      plot <- ggplot(data = arson_data)
      
      if (input$reported) {
        plot <- plot + geom_line(mapping = aes(x = year, y = reported), color = "blue")
      }
      
      if (input$confirmed) {
        plot <- plot + geom_line(mapping = aes(x = year, y = actual), color = "red")
      }
      
      if (input$damage) {
        plot <- plot + geom_line(mapping = aes(x = year, y = est_damage_value))
      }
      
      plot
    }
    
  })
}

shinyApp(ui, server)
