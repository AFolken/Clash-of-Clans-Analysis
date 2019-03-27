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
    selectInput("variable", "Select Plot:", 
                choices = c("clash_troops","clash_troops2"))
    
    # Input: Checkbox for whether outliers should be included ----
    #checkboxInput("outliers", "Show outliers", TRUE)
    
  ),
  
  # Main panel for displaying outputs ----
  mainPanel(
    # Output: Formatted text for caption ----
    # h3(textOutput("caption")),
    
    # Output: Plot of the requested variable against mpg ----
    plotlyOutput("plot")
  )
)

# Data pre-processing ----

clash_troops <- read_excel("clash.xlsx",sheet = "Troops")

clash_troops2 <- clash_troops

clash_troops2$cost <- clash_troops$cost/clash_troops$housing
clash_troops2$damage_per_second <- clash_troops$damage_per_second/clash_troops$housing
clash_troops2$hitpoints <- clash_troops$hitpoints/clash_troops$housing



colorscheme = c('#b50606','#fcd944','#0c6d63','#0b2a75','#572E8A')


server <- function(input, output) {
  
  # Generate a plot of the requested variable against mpg ----
  # and only exclude outliers if requested
  inputgraph <- reactive(input$variable)
  
  output$plot <- renderPlotly({
    p <- plot_ly(clash_troops, x = ~damage_per_second, y = ~hitpoints, z = ~cost, color = ~troop, colors = colorscheme) %>%
                              add_markers() %>%
                              layout(title = 'Troops',
                                     scene = list(xaxis = list(title = 'Damage/Second'),
                                                  yaxis = list(title = 'Hitpoints'),
                                                  zaxis = list(title = 'Cost')))
                      })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

