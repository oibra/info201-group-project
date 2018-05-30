library(shiny)

source("national_crime_trends.R")

ui <- navbarPage("Pages",
  tabPanel("Omar",
           titlePanel("National Arson Data"),
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
               
               textOutput("va_note", )
             ),
             
             mainPanel(
               fluidRow(
                 column(6, plotOutput("cases_plot", click = "plot_click")),
                 column(6, plotOutput("damage_plot")))
             )
           )),
  tabPanel("Jenni"),
  tabPanel("Sabrina"),
  tabPanel("Manu")
)

shinyUI(ui)