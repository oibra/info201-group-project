library(shiny)
library(plotly)

source("analysis.R")
source("national_crime_trends.R")

type_possibilities_seattle <- c("Homicide", "Rape", "Robbery", "Assault", "Larceny-Theft", "Burglary",
                                "Motor Vehicle Theft")

ui <- navbarPage(theme = "index.css", 
                 a(href = "https://github.com/oibra/info201-group-project", 
                   "Info 201 AC Team Red"),
  tabPanel("Home",
           h1("National Crime Data"),
           p("Include some descriptions here")
           ),
  tabPanel("Arson",
           h2("National Arson Data"),
           p("Arson is the criminal act of deliberately setting a fire, and",
             "is a large enough issue that the FBI keeps an entire publicly",
             "accessible database on it, which is what we used to provide",
             "this data. Our plots show data about reported number of cases", 
             "of arson, actual cases of arson, and total amount of property",
             "damage caused by arson from the years 1979 - 2016. The total",
             "actual cases of arson peaked at",
             strong(textOutput("peak_actual_cases", inline = T), inline = T),
             "cases in the year",
             strong(textOutput("peak_year", inline = T), inline = T), id = "arson-description"),
           
           br(),
           
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
                                   p("")),
                          tabPanel("Damages", 
                                   plotOutput("damage_plot"),
                                   p(""))
                          )
           ))),
  tabPanel('Prominent Crimes',
           h2("Persistent Crimes in the US"),
           h4("Page by Jeni Lane"),
           sidebarLayout(
            sidebarPanel(
              h3("Controls for Graphs:"),
              sliderInput("year", "Years", value = 2016, 
                         min = 1995, max = 2016, sep = ""),
              br(),
              selectInput("select_crime", "Select a Crime:",
                          c("Property Crime" = "property_crime",
                            "Violent Crime" = "violent_crime",
                            "Homicide" = "homicide",
                            "Rape" = "rape_legacy",
                            "Robbery" = "robbery",
                            "Aggravated Assault" = "aggravated_assault",
                            "Burglary" = "burglary",
                            "Larceny" = "larceny",
                            "Motor Vehicle Theft" = "motor_vehicle_theft")),
              p(em("Note: This second selector is only for the second graph")),
              br(),
              tableOutput("prop_table")
              ),
          mainPanel(
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
                 '"offenses of burglary, larceny theft, motor vehicle theft, and arson."',
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
                 "leading to higher property crime percentage.",
                 "Overall, the average percentage of property crime is",
                 strong(textOutput("mean_percent", inline = T), inline = T),
                 "with the minimum percentage being",
                 strong(textOutput("min_percent", inline = T), inline = T),
                 "and the maximum percentage being",
                 strong(textOutput("max_percent", inline = T), inline = T),
                 "across the United States."
               ),
               br(),
               p(
                 "Below is an interactive plot of each states' population verus their total amount of property crimes.",
                 "Using the slider, the year of data can be change from 1995 up to the most",
                 "recent year of data (2016). The graph will load starting at 2016.",
                 "If a dot (state) is clicked on, a table will appear at the bottom",
                 "of the controls section of the screen",
                 "with information about that state's property crime data.",
                 "Some states overlap in positioning so several states may appear by",
                 "accident in the table due to coordinate positioning.",
                 "If a spot with no data is selected, the table will appear blank.",
                 "Each state is listed by its abbreviation of its name in the table."
               ),
               plotOutput("prop_plot", click = "prop_click"),
               br(),
               br(),
               p(
                 "Additionally, we have also provided an interactive graph made by Plotly",
                 "to show the plotting of different crimes compared with each states' population.",
                 "By using the dropdown bar in the controls area, you can switch what type",
                 "of crime is currently being used in the graph. You can also hover over",
                 "any of the plots in the graph and a small textbox will appear with data",
                 "about that point."
               ),
               plotlyOutput("all_crime_plot"),
               br()
             )
           )
  ),
  tabPanel("Sabrina"),
  tabPanel("Seattle Crimes",
           titlePanel("Seattle Based Crime Specifics"),
           sidebarLayout(
             sidebarPanel(
               selectInput("type_choice_seattle", label="Choose Type of Crime", type_possibilities_seattle),
               radioButtons("radio_seattle", label="Choose Year Wanted", 
                            choices = list("All" = -100, "2008" = 2008,
                                           "2009" = 2009, "2010" = 2010,
                                           "2011" = 2011, "2012" = 2012,
                                           "2013" = 2013, "2014" = 2014),
                            selected = -100)
             ),
             mainPanel(
               p("The data below summarizes the specific type of crime that is occuring
                 within Seattle itself. Please feel free to use the buttons on the side
                 to get more specific data regarding this information. Also, this is an
                 interactive graph, so you will be able to hover and take information from
                 this graph itself."),
               plotOutput('plot_seattle', click = "plot_click_seattle"),
               dataTableOutput('info_seattle'),
               p(textOutput('message_seattle'))
               )
             ))
)

shinyUI(ui)