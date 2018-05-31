library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)

source("national_crime_trends.R")
source("analysis.R")

server <- function(input, output) {
  output$cases_plot <- renderPlotly({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    #plot <- ggplot(data = arson_data)
    plot <- plot_ly(arson_data, x = ~year, y = ~actual, name = "Actual Cases", type = "scatter", mode = "none", fill = "tozery",
                    fillcolor = "tomato")
    
    # if ("reported" %in% input$choices) {
    #   plot <- plot + geom_area(mapping = aes(x = year, y = reported), fill = "yellow")
    # }
    # 
    # if ("confirmed" %in% input$choices) {
    #   plot <- plot + geom_area(mapping = aes(x = year, y = actual), fill = "tomato")
    # }
    
    plot #+ 
    #   geom_point(mapping = aes(x = year, y = actual), shape = 18, size = 3, color = "gray") +
    #   labs(title = "Arson Cases", x = "Year", y = "Cases") +
    #   theme_minimal()
  })
  
  output$damage_plot <- renderPlot({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    ggplot(data = arson_data) + 
      geom_bar(mapping = aes(x = year, y = est_damage_value), stat = "identity", fill = "green") +
      labs(title = "Est. Property Damage", x = "Year", y = "Damage Value ($)") +
      theme_minimal()
  })
  
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
  
  output$mean_percent <- renderText({
    paste0(mean_percentage, "%")
  })
  
  output$min_percent <- renderText({
    paste0(min_percentage, "%")
  })
  
  output$max_percent <- renderText({
    paste0(max_percentage, "%")
  })
  
  data <- reactiveValues()
  
  output$prop_plot <- renderPlot({
    input_year <- input$year
    recent_year <- filter(states_only, year == input_year)
    
    data$current_year <- input_year
    data$current_data <- recent_year
    
    plot <- ggplot(data = recent_year) +
      geom_point(aes(x = population, y = property_crime, color = state_abbr, size = 3),
                 show.legend = FALSE) +
      labs(title = paste("Population vs. Property Crime in", input_year),
          x = "Population", y = "Amount of Property Crime")
    
    plot
  })
  
  observeEvent(input$prop_click,{
    selected_state <- nearPoints(data$current_data, input$prop_click)
    
    selected_state <- selected_state %>% 
      select(-year) %>% 
      select(state_abbr, property_crime)
    
    if(length(selected_state$property_crime) != 0){
      selected_state$property_crime <- formatC(as.numeric(selected_state$property_crime), 
                                               format = "f", big.mark = ",", digits = 0)
    }
    
    colnames(selected_state) <- c("State", "Amount of Property Crimes") 
    
    data$prop_info <- selected_state
  })
  
  output$prop_table <- renderTable({
    data$prop_info
  })
  
  getTitle <- reactive({
    my_title <- switch(input$select_crime,
                       property_crime = "Property Crime",
                       violent_crime = "Violent Crime",
                       homicide = "Homicides",
                       rape_legacy = "Rape",
                       robbery = "Robberies",
                       aggravated_assault = "Aggravated Assaults",
                       burglary = "Burglaries",
                       larceny = "Larceny",
                       motor_vehicle_theft = "Motor Vehicle Thefts")
    
    my_title
  })
  
  output$all_crime_plot <- renderPlotly({
    y_title <- getTitle()
    data_type <- input$select_crime
    
    selected_data <- data$current_data %>% 
      select(data_type)
    
    plot2 <- ggplot(data = data$current_data) +
      geom_point(aes(x = population, y = selected_data, color = state_abbr),
                 show.legend = FALSE) +
      labs(title = paste("Population vs.", y_title, "in", data$current_year),
           x = "Population", y = paste("Amount of", y_title))
    
    plotly_plot <- hide_legend(ggplotly(plot2))
  })

}

shinyServer(server)