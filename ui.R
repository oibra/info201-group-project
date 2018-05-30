library(shiny)

source("national_crime_trends.R")

ui <- navbarPage("Pages",
  tabPanel("Home"),
  tabPanel("Arson",
           tags$h1("National Arson Data"),
           sidebarLayout(
            sidebarPanel(
              selectInput("state", "State: ", choices = states,
                           selected = "Washington"),
               
              br(),
               
              checkboxGroupInput("choices", "Plot: ", 
                                  c("Reported Cases" = "reported", 
                                    "Confirmed Cases" = "confirmed"),
                                  selected = "confirmed"),
               
              br(),
               
              sliderInput("years", "Years", c(1979, 2016), min = 1979, max = 2016),
              
              tags$hr(),
               
              tags$blockquote("Note: Virginia has been removed as there is not adequet data on VA 
                              to create a visualization.")
            ),
             
            mainPanel(
              tabsetPanel(type = "tabs",
                          tabPanel("Arson Cases", plotlyOutput("cases_plot")),
                          tabPanel("Damages", plotOutput("damage_plot")))
           ))),
  tabPanel("Jenni"),
  tabPanel("Sabrina"),
  tabPanel("Manu")
)

shinyUI(ui)