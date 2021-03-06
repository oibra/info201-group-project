library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)
library(maps)

source("summarize.R")
source("national_crime_trends.R")
source("analysis.R")

seattle_data <- read.csv("data/Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv")

server <- function(input, output) {
  #Omar
  output$cases_plot <- renderPlot({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    plot <- ggplot(data = arson_data)
    
    if ("reported" %in% input$choices) {
      plot <- plot + geom_area(mapping = aes(x = year, y = reported), fill = "#e17a57")
    }

    if ("confirmed" %in% input$choices) {
      plot <- plot + geom_line(mapping = aes(x = year, y = actual), color = "#c74b4b", size = 1.5)
    }
    
    plot +
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
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    max_cases <- arson_data %>% 
      filter(est_damage_value == max(est_damage_value))
    
    min_cases <- arson_data %>% 
      filter(est_damage_value == min(est_damage_value))
    
    paste0("Shown here is the data for the state of ", input$state, " from ", input$years[1], " to ", 
          input$years[2], ". The least arson cases in the state was ", 
          min_cases$actual, " cases in the year ", min_cases$year, " while the most was ",
          max_cases$actual, " cases in the year ", max_cases$year, ".")
  })
  
  output$cases_details <- renderText({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    points <- nearPoints(arson_data, input$arson_plot_click)
    
    if (nrow(points) > 0) {
      data <- paste("In", input$state, "in the year", points[[1,2]], ", there were",
                    points[[1,7]], "cases of arson")
      
      if ("reported" %in% input$choices) {
        data <- paste0(data, ", out of a total of ", points[[1,5]], " reported cases of arson.")
      }
    } else {
      data <- ""
    }
    
    data
  })
  
  observeEvent(input$arson_plot_click, {
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    selected_year <- nearPoints(arson_data, input$arson_plot_click)
  })
  
  output$arson_damage_data <- renderText({
    state <- state.abb[grep(input$state, state.name)]
    arson_data <- state_arson_data(state, input$years[1], input$years[2])
    
    max_damage <- arson_data %>% 
      filter(est_damage_value == max(est_damage_value))
    
    min_damage <- arson_data %>% 
      filter(est_damage_value == min(est_damage_value))
    
    paste0("Shown here is the data for the state of ", input$state, " from ", input$years[1], " to ", 
          input$years[2], ". The least damage caused by arson in the state was $", 
          min_damage$est_damage_value, " in the year ", min_damage$year, " while the most was $",
          max_damage$est_damage_value, " in the year ", max_damage$year, ".")
  })
  
  #Jeni
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

  #Manu
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
  
  #Sabrina
  getType <- reactive({
    data.type <-  switch (
      input$data,
      property_crime = "Property Crime",
      violent_crime = "Violent Crime",
      homicide = "Homicides",
      rape_legacy = "Rape",
      robbery = "Robberies",
      aggravated_assault = "Aggravated Assaults",
      burglary = "Burglaries",
      larceny = "Larceny",
      motor_vehicle_theft = "Motor Vehicle Thefts"
    )
  })

  #Sabrina
  output$table.info <- renderText({
    paste("This table shows the", input$data, "data for the year", input$year,
                                        "with a minimum threshold of", input$obs, "for each arrest made that year.")
    })

  output$map.info <- renderText({paste("The map below is a chloropleth map showing the", input$data,
                                      "comparing the arrest percentages in the year", input$year, "based on each crime that was committed.
                                      This map only shows the arrests that are above this", input$obs, ".", "We can gather from this data that the amount
                                      of crimes that are being committed and the amount of total arrests does not match up. Crimes are being reported but arrested
                                      does not correlate")
  })

  output$country.info = renderText({
    xy_str <- function(e) {
      if(is.null(e)) {
        return("")
      } else {
        country <- GetCountryAtPoint(e$x, e$y)
        country.data <- GetData(getType(), input$year, 0)
        return(paste0(country, " ", input$data, " in the year ", input$year, ": ", country.data[country, 2]))
      }
    }
    xy_str(input$plot_click)
    GetData(getType(), input$year, input$obs)
  })

  output$type <- renderText({
    paste("Minimum threshold of", input$data)
  })

  # output$table <- renderTable({
  #   data.table()
  # })
  # 
  # output$plot <- renderPlot({
  #   plot(GetPlot(data.table(), input$year, input$obs, input$data))
  # })
  
}

shinyServer(server)
