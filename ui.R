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
           h4("Omar Ibrahim | Jeni Lane | Sabrina Mohamed | Mrinal Sharma", id = "authors"),
           
           h1("National Crime Data"),
           
           p("Our country is at a point where we are more aware of crime and our criminal",
             "justice system then ever before. And with our heightened awareness and heightened",
             "empathy, people are more interested in knowing what is going on in their country",
             "than ever before. While it may seem that things are the worst they've ever been",
             "it is important to remember that it only seems that way because we live in a time",
             "where we are able to be more aware of what is happening than ever before. As",
             "hopeless as it may seem at times, data across the board shows that that simply is",
             "not true. Crime rates are at some of the lowest rates they've been in decades.",
             "The data we've collected all shows the same thing; crime is at a relatively low",
             "point, and as citizens we have to understand that data."),
           
           br(),
           
           p("We used three main data sources to create our presentation. The first is the FBI",
             "Crime Data API, which has a plethora of data collected by the FBI on crime in the",
             "US and stretches from 1979 to 2016. It isn't documented well, which makes it",
             "difficult for new users to use, but the data provided is very extensive and lets",
             "us see some extremely interesting crime statistics. We used the FBI Crime Data API",
             "to analyze patterns in arson cases across the US and to analyze top crimes in each",
             "state and over time."),
           
           p("We also used a database from the Seattle Police to analyze the statistics of", 
             "different types of crime in Seattle from 2008-2014. The third dataset we use was",
             "a csv file on national crime data from 1995-2016."),
           
           br(),
           
           h2("Sources:"),
           a(href = "https://crime-data-explorer.fr.cloud.gov/api#/", "FBI Crime Data API", 
             class = "source"),
           a(href = "https://data.seattle.gov/Public-Safety/Seattle-Crime-Stats-by-Police-Precinct-2008-Presen/3xqu-vnum",
             "Seattle Crime Stats by Police Precinct 2008-Present", class = "source")
           ),
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
  
  tabPanel("Arson",
           h2("National Arson Data"),
           h4("Page by Omar Ibrahim"),
           p("Arson is the criminal act of deliberately setting a fire, and",
             "is a large enough issue that the FBI keeps an entire publicly",
             "accessible database on it, which is what we used to provide",
             "this data. Our plots show data about reported number of cases", 
             "of arson, actual cases of arson, and total amount of property",
             "damage caused by arson from the years 1979 - 2016. The total",
             "actual cases of arson nationally peaked at",
             strong(textOutput("peak_actual_cases", inline = T), inline = T),
             "cases in the year",
             strong(textOutput("peak_year", inline = T), inline = T), 
             "while national property damage caused by arson peaked at ",
             strong(textOutput("peak_damage", inline = T), inline = T),
             "in the year",
             strong(textOutput("peak_damage_year", inline = T), inline = T),
             ". Last year, most of the west coast was on fire. Unfortunately, none of our data",
             "covers that period of time. The more the climate changes, the easier it is for",
             "fires to start and arson to become more damaging.",
             class = "arson-description"),
            
           
           br(),
           
           sidebarLayout(
             
            sidebarPanel(
              selectInput("state", "State: ", choices = states,
                           selected = "Washington"),
               
              br(),
               
              sliderInput("years", "Years", c(1979, 2016), min = 1979, max = 2016, sep = ""),
              
              br(),
              
              checkboxGroupInput("choices", "Plot: ", 
                                 c("Reported Cases" = "reported", 
                                   "Confirmed Cases" = "confirmed"),
                                 selected = "confirmed"),
              
              hr(),
               
              p(em("Notes: ")),
              p(em("Virginia has been removed as there is not adequet data on VA to create a",
                   "visualization.")),
              p(em("Plot selector is only for first graph."))
            ),
             
            mainPanel(
              
              tabsetPanel(type = "tabs",
                          tabPanel("Arson Cases", 
                                   plotOutput("cases_plot", click = "arson_plot_click"),
                                   p("This graph shows data on actual and reported cases of arson.",
                                     textOutput("arson_case_data", inline = T),
                                   p("", (textOutput("cases_details", inline = T))))),
                          tabPanel("Damages", 
                                   plotlyOutput("damage_plot"),
                                   p("This plot shows data about the monetary value of property",
                                     "damage causes by arson.",
                                     textOutput("arson_damage_data", inline = T)))
                          )
           )),
           
           br(),
           
           p("If you are witness to an act of arson, please alert the proper authorities as soon",
             "as possible. Fires can grow out of control extremely quickly, and are both an",
             "extreme danger to public health and to the environment. Close to 3300 people died in",
             "fires in the US in 2015, and in the summer of 2017, California, Oregon, Wahington,",
             "and British Columbia were all on fire. The sky was completely covered in smoke.",
             "While not all fires are arson, arson is a large contibutor.", 
             class = "arson-description")
           ),
  
  tabPanel("Seattle Crimes",
           h2("Seattle Based Crime Specifics"),
           h4("Page by Manu Sharma"),
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
             )),

  tabPanel("Top Crimes",
           h2("Top Crime by Year"),
           h4("Page by Sabrina Mohamed"),

           # Sidebar layout with input and output definitions ----
           sidebarLayout(

           #Sidebar panel for inputs ----
           sidebarPanel(

             h4("Control Widgets:"),


             # Input: Select the random distribution type ----
             selectInput("data", "Data type:",
                         choices = c(
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
                         1996,
                         min = 1996,
                         max = 2016),



             numericInput("obs", textOutput("type"), 0, min = 0, max = NA)
           ),

             # Main panel for displaying outputs ----
             mainPanel(

               # Output: Tabset w/ plot, summary, and table ----
               tabsetPanel(type = "tabs",
                           tabPanel("Table", p(textOutput("table.info")), tableOutput("table"), p("404: Sorry, we can't find your table.")),
                           tabPanel("Plot", p(textOutput("map.info")), plotOutput("plot", click = "plot_click"), p(textOutput("percentage"),
                                    p("404: Sorry, we can't seem to find your plot")))
               )


             )
           ))
 
)

shinyUI(ui)