library(shiny)
library(dplyr)
library(plotly)

source("national_crime_trends.R")

source("analysis.R")

server <- function(input, output) {
  output$cases_plot <- renderPlot({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    plot <- ggplot(data = arson_data)
    
    if ("reported" %in% input$choices) {
      plot <- plot + geom_area(mapping = aes(x = year, y = reported), fill = "yellow")
    }

    if ("confirmed" %in% input$choices) {
      plot <- plot + geom_line(mapping = aes(x = year, y = actual), color = "tomato", size = 1.5)
    }
    
    plot +
      geom_point(mapping = aes(x = year, y = actual), shape = 18, size = 3, color = "gray") +
      labs(title = "Arson Cases", x = "Year", y = "Cases") +
      theme_minimal()
  })
  
  output$peak_actual_cases <- renderText({
    arson_data <- national_arson_data()
    arson_data <- arson_data %>% 
      filter(actual == max(actual)) %>% 
      select(actual)
    arson_data[[1]]
  })
  
  output$peak_year <- renderText({
    arson_data <- national_arson_data()
    arson_data <- arson_data %>% 
      filter(actual == max(actual)) %>% 
      select(year)
    arson_data[[1]]
  })
  
  output$damage_plot <- renderPlot({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    ggplot(data = arson_data) + 
      geom_bar(mapping = aes(x = year, y = est_damage_value), stat = "identity", fill = "#85bb65") +
      labs(title = "Est. Property Damage", x = "Year", y = "Damage Value ($)") +
      theme_minimal()
  })
  
  data <- reactiveValues()
  
  output$state_name_t <- renderText({
    state_name
  })
  
  output$cali_pop <- renderText({
    cal_population
  })
  
  output$cali_percent <- renderText({
    paste0(cal_percentage, "%")
  })
  
  output$cali_ver_range <- renderText({
    paste0(cali_vermont_range, "%")
  })
  
  output$vermont_percent <- renderText({
    paste0(vermont_percentage, "%")
  })
  
  output$cali_wash_range <- renderText({
    paste0(cali_wash_range, "%")
  })
  
  output$wash_percent <- renderText({
    paste0(wash_percentage, "%")
  })
  
  output$prop_plot <- renderPlot({
    plot
  })

}

shinyServer(server)