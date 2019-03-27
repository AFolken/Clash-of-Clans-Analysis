#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(readxl)

# Define UI for application that draws a histogram
ui <- pageWithSidebar(
  
  # App title ----
  headerPanel("Clash Analysis"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    
    # Input: Selector for variable to plot against mpg ----
    selectInput("variable", "Variable:", 
                c("Troops" = "p",
                  "Troopos2" = "p2")),
    
    # Input: Checkbox for whether outliers should be included ----
    checkboxInput("outliers", "Show outliers", TRUE)
    
  ),
  
  # Main panel for displaying outputs ----
  mainPanel(
    # Output: Formatted text for caption ----
    # h3(textOutput("caption")),
    
    # Output: Plot of the requested variable against mpg ----
    plotOutput("mpgPlot")
  )
)

# Data pre-processing ----
# Tweak the "am" variable to have nicer factor labels -- since this
# doesn't rely on any user inputs, we can do this once at startup
# and then use the value throughout the lifetime of the app
mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

clash_troops <- read_excel("H:/My Documents/clash.xlsx",sheet = "Troops")
clash_defense <- read_excel("H:/My Documents/clash.xlsx",sheet = "Defense")
clash_heros <- read_excel("H:/My Documents/clash.xlsx",sheet = "Heros")
clash_buildings <- read_excel("H:/My Documents/clash.xlsx",sheet = "Buildings")

clash_troops$cost2 <- clash_troops$cost/clash_troops$housing
clash_troops$damage_per_second2 <- clash_troops$damage_per_second/clash_troops$housing
clash_troops$hitpoints2 <- clash_troops$hitpoints/clash_troops$housing

colorscheme = c('#b50606','#fcd944','#0c6d63','#0b2a75','#572E8A')


server <- function(input, output) {
  
  # Generate a plot of the requested variable against mpg ----
  # and only exclude outliers if requested
  inputgraph <- reactive(input$variable)
    
  
  
  p <- plot_ly(clash_troops, x = ~damage_per_second, y = ~hitpoints, z = ~cost, color = ~troop, colors = colorscheme) %>%
    add_markers() %>%
    layout(title = 'Troops',
           scene = list(xaxis = list(title = 'Damage/Second'),
                        yaxis = list(title = 'Hitpoints'),
                        zaxis = list(title = 'Cost')))
  
  
  #features including a 2 are calculated out of housing space required
  
  p2 <- plot_ly(clash_troops, x = ~damage_per_second2, y = ~hitpoints2, z = ~cost2, color = ~troop,colors = colorscheme) %>%
    add_markers() %>%
    layout(title = 'Troops by House Space',
           scene = list(xaxis = list(title = 'Damage/Second'),
                        yaxis = list(title = 'Hitpoints'),
                        zaxis = list(title = 'Cost')))
  output$mpgPlot <- inputgraph
  
}

# Run the application 
shinyApp(ui = ui, server = server)

