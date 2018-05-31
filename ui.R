library(shiny)
library(ggplot2)
library(dplyr)
source(summarize.R)
my.ui <- fluidPage(
  # App title ----
  titlePanel("Top Crime by Year"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      h1("Control Widgets:"), 
      
      
      # Input: Select the random distribution type ----
      selectInput("data", "Data type:",
                  c(
                    input$data,
                    property_crime = "Property Crime",
                    violent_crime = "Violent Crime",
                    homicide = "Homicides",
                    rape_legacy = "Rape",
                    robbery = "Robberies",
                    aggravated_assault = "Aggravated Assaults",
                    burglary = "Burglaries",
                    larceny = "Larceny",
                    motor_vehicle_theft = "Motor Vehicle Thefts")
      ),
      
      # br() element to introduce extra vertical spacing ----
      br(),
      
      # Input: Slider for the number of observations to generate ----
      sliderInput("year",
                  "Year of observations",
                  min = 1996,
                  max = 2016),
      
      
      
      numericInput("obs", textOutput("type"), 0, min = 0, max = NA)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Table", p(textOutput("table.info")), tableOutput("table")),
                  tabPanel("Plot", p(textOutput("map.info")), plotOutput("plot", click = "plot_click"), p(textOutput("percentage")))
      )
      
      
    )
  )
)

shinyUI(my.ui)
