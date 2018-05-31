library(shiny)

source("analysis.R")
source("national_crime_trends.R")

ui <- navbarPage("Info 201 AC Team Red",
  tabPanel("Home",
           h1("National Crime Data"),
           p("Include some descriptions here")
           ),
  tabPanel("Arson",
           h2("National Arson Data"),
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
               
              sliderInput("years", "Years", c(1979, 2016), min = 1979, max = 2016, sep = ""),
              
              tags$hr(),
               
              tags$blockquote("Note: Virginia has been removed as there is not adequet data on VA 
                              to create a visualization.")
            ),
             
            mainPanel(
              tabsetPanel(type = "tabs",
                          tabPanel("Arson Cases", 
                                   plotOutput("cases_plot"),
                                   p()),
                          tabPanel("Damages", 
                                   plotOutput("damage_plot"),
                                   p())
                          )
           ))),
  tabPanel("Property Crime",
           sidebarLayout(
             
             sidebarPanel(
               radioButtons("stats", "Evictions vs Other Rates (select one):",
                            c("Poverty Rate" = "pov_rate",
                              "Median Household Income" = "med_house_inc",
                              "Renter Occupied Households" = "rent_occ_house",
                              "Rent Burden" = "rent_burden")),
               br(),
               sliderInput("year", "Years", value = 21, 
                           min = 1995, max = 2016, sep = "")
             ),
             mainPanel(
               h4("What crime is 'trending' in the US today?"),
               p("In recent months, the media has been rampant with new crimes,",
                 "and blasting cries for change from the people of the United States.",
                 'Beginning back in 2013, when the "Black Lives Matter" movement started',
                 "after the murder of Trayvon Martin, the media slowly began to change",
                 "to reflect the new wave of political change that a majority of the",
                 "population rallied for. Martin's death was a spark for finding several",
                 "holes within our country's legal system and law enforcement - ",
                 "leading to disclosure and exposure of police brutality against black",
                 "communities and other acknowledgement of corruption in our society",
                 'with incidents such as the "Me Too" movement for recognizing',
                 "sexual assault and the eruption of discoveries regarding sexual",
                 "predators and child molesters in Hollywood.",
                 "With new crimes being broadcasted on our social media daily,",
                 'some people might ask, "What kinds of crime are on the rise now?"',
                 "The following data, taken from the Crime Data Explorer of the",
                 "US government, seeks to look further at some of the greater crimes",
                 "the have also been prevalent in our legal system as of late."
               ),
               br(),
               p("Despite the thousands of hate crimes, sexual offenses, and shootings,",
                 "that have been occuring recently in America, the most protrusive crime",
                 "as of late remains being",
                 strong("Property Crime."),
                 "Property Crime includes, as stated by the Uniform Crime Reporting Program,",
                 '"offenses of burglary, larceny theft, motor vehicle theft, and arson.',
                 em("For more about the United States recent arson crimes, check out our 'Arson' tab at the top of this page."),
                 "Out of all the 51 US States (including District of Columbia),",
                 strong(textOutput("state_name_t", inline = T),inline = T),
                 "happens to be the state with the highest total amount of",
                 "property crimes throughout all our years of data.",
                 "With a population of",
                 strong(textOutput("cali_pop", inline = T), inline = T),
                 "citizens, property crime is taking up a whopping",
                 strong(textOutput("cali_percent", inline = T), inline = T),
                 "of all crimes in California as of 2016. In comparison with states like",
                 "Vermont (the state with the lowest amount of property crime in 2016)",
                 "and Washington State, California's percentage of property crimes is",
                 strong(textOutput("cali_ver_range", inline = T), inline =  T),
                 em("less"), 
                 "than Vermont's ",
                 strong(textOutput("vermont_percent", inline = T), inline = T),
                 "and",
                 strong(textOutput("cali_wash_range", inline = T), inline = T),
                 em("less"), 
                 "than Washington's ",
                 strong(textOutput("wash_percent", inline = T), inline = T),
                 "property crime out of all total crimes for each state in 2016.",
                 "This change in percentage is due to the total amount of crimes",
                 "occuring in each state being less than California's crime total,",
                 "leading to higher property crime percentage overall."
               ),
               plotOutput("prop_plot")
             )
           )
  ),
  tabPanel("Sabrina"),
  tabPanel("Manu")
)

shinyUI(ui)