library(shiny)

# Define UI for application that draws a histogram
# shinyUI(fluidPage(
#   
#   title = "US Energy",
#   h1("US Energy"),
#   h2("Energy capacity in Million BTU by sources",align="center"),
#   fluidRow(column(1,align="center",h4("capacity (million BTU)")),column(11,streamgraphOutput('stream'))),
#   fluidRow(column(4,plotOutput('pie')),column(8,plotOutput('line'))),
#   fluidRow(column(4,wellPanel(sliderInput("year","Year for pie chart: ",1960,2013,value=2000,step=1))),
#            column(4,offset=2,wellPanel(sliderInput("yearRange","Year Range for line plot: ",1960,2013,value=c(1960,2010)),step=1)))
#   )
# )


shinyUI(navbarPage("US Energy Production",
  tabPanel("Overview",
  titlePanel("US Energy"),
 
    fluidRow(column(4,wellPanel(sliderInput("yearRange","Select year range: ",1960,2013,value=c(1960,2010)),
                 sliderInput("year","Select specific year for pie chart: ",1960,2013,value=2000,step=1))),
             column(8,wellPanel(h4("Energy production"),plotOutput('stream')))),
    fluidRow(column(4,wellPanel(h4("Pie chart of energy sources"),plotOutput('pie'))),column(8,wellPanel(h4("Energy trends over the years"),plotOutput('line'))))
    ),
  tabPanel("States",fluidRow(column(4,wellPanel(sliderInput("sel_year","Select year: ",1960,2013,value=2000,step=1),
                                                selectInput("sel_state", "Select your state:", choices = c("AK","AL","AR", "AZ", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI" ,"MN", "MO", "MS", "MT","NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK" ,"OR", "PA", "RI", "SC" ,"SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY"))
                                                ,verbatimTextOutput("st_production"),
                                                verbatimTextOutput("st_consumption")))
                             ,column(8,plotOutput('state_barplot'))))
)
)


# shinyUI(fluidPage(
#   
#   titlePanel("US Energy"),
#   sidebarLayout(
#     sidebarPanel(sliderInput("yearRange","Select year range: ",1960,2013,value=c(1960,2010)),
#                  sliderInput("year","Select specific year for pie chart: ",1960,2013,value=2000,step=1),
#                  plotOutput('pie')
#     ),
#     mainPanel(streamgraphOutput('stream'),plotOutput('line'))
#   )
# )
# )
