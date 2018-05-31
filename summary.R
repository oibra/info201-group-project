library("dplyr")
library("ggplot2")
library("maps")

library("shiny")
library("dplyr")


my.server <- function(input, output) {
  
  data.table <- reactive({
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
    output$table.info <- renderText(paste("This table shows the", input$data, "data for the year", input$year, 
                                          "with a minimum threshold of", input$obs, "for each country that is above the minimum."))
    output$map.info <- renderText(paste("The map below is a chloropleth map showing the", input$data,
                                        "comparing the evicition percentages in the year", input$year, "for each state based on the 
                                        race. This map only shows the countries that are above the minimum treshold of", input$obs, "."))
    output$country.info = renderText({
      xy_str <- function(e) {
        if(is.null(e)) {
          return("")
        } else {
          country <- GetCountryAtPoint(e$x, e$y)
          country.data <- GetData(data.type, input$year, 0)
          return(paste0(country, " ", input$data, " in the year ", input$year, ": ", country.data[country, 2]))
        }
      }
      xy_str(input$plot_click)
    })
    return(GetData(data.type, input$year, input$obs))
  })
  
  output$type <- renderText({
    return(paste("Minimum threshold of", input$data))
  })
  
  output$table <- renderTable({
    data.table()
  })
  
  output$plot <- renderPlot({
    plot(GetPlot(data.table(), input$year, input$obs, input$data))
  })
  
  
  
  }

shinyServer(my.server)




