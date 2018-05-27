library(shiny)

ui <- navbarPage("Pages",
  tabPanel("Omar",
           sidebarLayout(
             sidebarPanel(),
             mainPanel()
           )),
  tabPanel("Jenni"),
  tabPanel("Sabrina"),
  tabPanel("Manu")
)

shinyUI(ui)