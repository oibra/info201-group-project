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
      selectInput("state", "State: ", choices = #append(state.name, "National", 26), 
                    state.name,
                  selected = "Washington"),
      
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
      plotOutput("plot"),
      textOutput("test")
    )
  )
)

server <- function(input, output) {
  output$test <- renderText({
      paste("The confirmed value is true", input$choices)
  })
  
  output$plot <- renderPlot({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state)
    
    plot <- ggplot(data = arson_data)# + geom_line(mapping = aes(x = year, y = actual), color = "red")
    
    if ("reported" %in% input$choices) {
      plot <- plot + geom_line(mapping = aes(x = year, y = reported), color = "blue")
    }
    
    if ("confirmed" %in% input$choices) {
      plot <- plot + geom_line(mapping = aes(x = year, y = actual), color = "red")
    }
    
    if ("damage" %in% input$choices) {
      plot <- plot + geom_line(mapping = aes(x = year, y = est_damage_value))
    }
    
    plot
  })
}

shinyApp(ui, server)
