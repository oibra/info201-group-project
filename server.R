library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)

source("national_crime_trends.R")
source("analysis.R")

seattle_data <- read.csv("data/Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv")

server <- function(input, output) {
  output$cases_plot <- renderPlot({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    plot <- ggplot(data = arson_data)
    
    if ("reported" %in% input$choices) {
      plot <- plot + geom_area(mapping = aes(x = year, y = reported), fill = "#ffb400")
    }

    if ("confirmed" %in% input$choices) {
      plot <- plot + geom_line(mapping = aes(x = year, y = actual), color = "#ff0000", size = 1.5)
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
  
  output$peak_damage <- renderText({
    arson_data <- national_arson_data()
    arson_data <- arson_data %>% 
      filter(est_damage_value == max(est_damage_value)) %>% 
      select(est_damage_value)
    paste0("$", arson_data[[1]])
  })
  
  output$peak_damage_year <- renderText({
    arson_data <- national_arson_data()
    arson_data <- arson_data %>% 
      filter(est_damage_value == max(est_damage_value)) %>% 
      select(year)
    arson_data[[1]]
  })
  
  output$damage_plot <- renderPlotly({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    plot <- ggplot(data = arson_data) + 
      geom_bar(mapping = aes(x = year, y = est_damage_value), stat = "identity", fill = "#85bb65") +
      labs(title = "Est. Property Damage", x = "Year", y = "Damage Value ($)") +
      theme_minimal()
    
    hide_legend(ggplotly(plot))
  })
  
  output$arson_case_data <- renderText({
    paste("Shown here is the data for the state of", input$state, "from", input$years[1], "to", 
          input$years[2], ".")
  })
  
  output$arson_damage_data <- renderText({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    max_damage <- arson_data %>% 
      filter(est_damage_value == max(est_damage_value))
    
    min_damage <- arson_data %>% 
      filter(est_damage_value == min(est_damage_value))
    
    paste("Shown here is the data for the state of", input$state, "from", input$years[1], "to", 
          input$years[2], ".")
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

  filtered_plot <- reactive({
    data <- filter(seattle_data, Year == input$radio_seattle) %>% 
      group_by(CRIME_TYPE) %>% 
      summarize(Count = sum(STAT_VALUE))
    return (data)
  })
  
  other_filtered_plot <- reactive({
    seattle <- group_by(seattle_data, Year) %>% 
      mutate(sum_total = sum(STAT_VALUE)) %>% 
      filter(CRIME_TYPE == input$type_choice_seattle) %>% 
      summarize(Count = sum(STAT_VALUE),
                actual_plot = ((sum(STAT_VALUE) / sum_total[1]) * 100))
    return(seattle)
  })
  
  output$plot_seattle <- renderPlot({
    if (input$radio_seattle != -100) {
      g <- ggplot(data=filtered_plot(), aes(x=CRIME_TYPE, y=Count)) +
        geom_bar(stat="identity", fill = "#FF6666") + 
        labs(title = paste("Different amount of crime for the year", input$radio_seattle), 
             y = "Count of Criminal Activity",
             x = "Type of Criminal Event")
    } else {
      g <- ggplot(data = other_filtered_plot(), aes(x=Year, y=actual_plot)) + 
        geom_line() + 
        geom_smooth(method = "lm", se = FALSE, color = "blue", size = 3) +
        labs(title = paste("Type of Crime throughout the Years"),
             y = "Percentage of This Specific Crime to Total Crime (%)",
             x = "Year")
    }
    g
  })
  
  output$info_seattle <- renderDataTable({
    if (input$radio_seattle != -100) {
      frame <- nearPoints(filtered_plot(), input$plot_click_seattle, threshold = 10, maxpoints = 1,
                          addDist = FALSE)
      colnames(frame) <- c("Type of Criminal Event", "Count of Criminal Activity")
      return (frame)
    } else {
      frame <- nearPoints(other_filtered_plot(), input$plot_click_seattle, threshold = 10, maxpoints = 1,
                          addDist = FALSE)
      colnames(frame) <- c("Year", "Count of Criminal Activity", "Ratio from Total Crime")
      return (frame)
    }
  })
  
  output$message_seattle <- renderText({
    data_name <- "null"
    if (input$radio_seattle == -100) {
      data_name <- "all years from 2008 to 2014."
    } else {
      data_name <- paste("the year ", input$radio_seattle, ".", sep="")
    }
    my_message <- paste("This is the data for", data_name)
    return(my_message)
  })
  
}

shinyServer(server)