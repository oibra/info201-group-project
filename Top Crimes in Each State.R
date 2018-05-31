library(shiny)

source("apiKey.R")

ui <- navbarPage("Pages",
                 tabPanel("Sabrina",
                          titlePanel("Top Crimes in Each State"),
                          sidebarLayout(
                            sidebarPanel(),
                            mainPanel()
                            sidebarPanel(
                              selectInput("state", "State: ", choices = states,
                              
                              br(),
                              
                              checkboxGroupInput("choices", "Plot: ", 
                                                 c("Reported Cases" = "Reported", 
                                                   "Confirmed Cases" = "Confirmed"),
                                                 selected = "Confirmed"),
                              
                              br(),
                              
                              sliderInput("years", "Years", c(1979, 2016), min = 1979, max = 2016),
                              
                            ),
                            
                            mainPanel(
                              fluidRow(
                                column(6, plotOutput("cases_plot", click = "plot_click")),
                            )
                          )),
