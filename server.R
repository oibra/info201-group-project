library(shiny)
library(dplyr)

source("national_crime_trends.R")

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
  
  output$va_note <- renderText({
    "Note: Virginia has been removed as there is not adequet data on VA to create a visualization."
  })
}

shinyServer(server)