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

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("state", "State: ", choices = #append(state.name, "National", 26), 
                    state.name,
                  selected = "Washington"),
      
      br(),
      
      checkboxGroupInput("choices", "Plot: ", 
                         c("Reported Cases" = "reported", 
                           "Confirmed Cases" = "confirmed"),
                         selected = "confirmed"),
      
      br(),
      
      sliderInput("years", "Years", c(1979, 2016), min = 1979, max = 2016)
    ),
    
    mainPanel(
      fluidRow(
        column(6, plotOutput("cases_plot", click = "plot_click")),
        column(6, plotOutput("damage_plot")))
    )
  )
)

server <- function(input, output) {
  output$cases_plot <- renderPlot({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    plot <- ggplot(data = arson_data)
    
    if ("reported" %in% input$choices) {
      plot <- plot + geom_area(mapping = aes(x = year, y = reported), fill = "blue")
    }
    
    if ("confirmed" %in% input$choices) {
      plot <- plot + geom_area(mapping = aes(x = year, y = actual), fill = "red")
    }
    
    plot + 
      geom_point(mapping = aes(x = year, y = actual), shape = 18, size = 3, color = "white") +
      labs(title = "Arson Cases", x = "Year", y = "Cases") +
      theme_dark()
  })
  
  output$damage_plot <- renderPlot({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    ggplot(data = arson_data) + 
      geom_bar(mapping = aes(x = year, y = est_damage_value), stat = "identity", fill = "green") +
      labs(title = "Est. Property Damage", x = "Year", y = "Damage Value ($)") +
      theme_dark()
  })
}

shinyApp(ui, server)
