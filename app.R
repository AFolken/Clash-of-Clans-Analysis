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
ui <- fluidPage(
  
  # App title ----
  headerPanel("Clash Analysis"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    
    # Input: Selector for variable to plot against mpg ----
    selectInput("variable", "Select Plot:", 
                choices = c("Troops","Troops/Housing Space","Defense","Heros","Buildings"))
    
    # Input: Checkbox for whether outliers should be included ----
    #checkboxInput("outliers", "Show outliers", TRUE)
    
  ),
  
  # Main panel for displaying outputs ----
  mainPanel(
    plotlyOutput("plot"),
    width = 12
  )
)

# Data pre-processing ----

clash_troops <- read_excel("H:/My Documents/clash.xlsx",sheet = "Troops")
clash_defense <- read_excel("H:/My Documents/clash.xlsx",sheet = "Defense")
clash_heros <- read_excel("H:/My Documents/clash.xlsx",sheet = "Heros")
clash_buildings <- read_excel("H:/My Documents/clash.xlsx",sheet = "Buildings")


clash_troops$cost2 <- clash_troops$cost/clash_troops$housing
clash_troops$damage_per_second2 <- clash_troops$damage_per_second/clash_troops$housing
clash_troops$hitpoints2 <- clash_troops$hitpoints/clash_troops$housing

colorscheme = c('#b50606','#fcd944','#0c6d63','#0b2a75','#572E8A')

#graphs
p <- plot_ly(clash_troops, x = ~damage_per_second, y = ~hitpoints, z = ~cost, color = ~troop, size = ~hitpoints,sizes = c(100,10000), colors = colorscheme,width=1000,height=1000) %>%
  add_markers() %>%
  layout(title = 'Troops',
         scene = list(xaxis = list(title = 'Damage/Second'),
                      yaxis = list(title = 'Hitpoints'),
                      zaxis = list(title = 'Cost')))


#features including a 2 are calculated out of housing space required

p2 <- plot_ly(clash_troops, x = ~damage_per_second2, y = ~hitpoints2, z = ~cost2, color = ~troop,size = ~hitpoints2,sizes = c(100,10000),colors = colorscheme,width=1000,height=1000) %>%
  add_markers() %>%
  layout(title = 'Troops by House Space',
         scene = list(xaxis = list(title = 'Damage/Second'),
                      yaxis = list(title = 'Hitpoints'),
                      zaxis = list(title = 'Cost')))


#buildings
D <- plot_ly(clash_defense, x = ~damage_per_second, y = ~hitpoints, z = ~Range, color = ~building,size = ~hitpoints,sizes = c(100,10000), colors = colorscheme,width=1000,height=1000) %>%
  add_markers() %>%
  layout(title = 'Defense',
         scene = list(xaxis = list(title = 'Damage/Second'),
                      yaxis = list(title = 'Hitpoints'),
                      zaxis = list(title = 'Range')))


H <- plot_ly(clash_heros, x = ~damage_per_second, y = ~hitpoints, z = ~Range, color = ~hero,size = ~hitpoints,sizes = c(100,10000), colors = colorscheme,width=1000,height=1000) %>%
  add_markers() %>%
  layout(title = 'Heros',
         scene = list(xaxis = list(title = 'Damage/Second'),
                      yaxis = list(title = 'Hitpoints'),
                      zaxis = list(title = 'Range')))

buildingslist <- arrange(clash_buildings, -hitpoints)
buildingsarray <- as.array(buildingslist$building)

B <- plot_ly(clash_buildings, x = ~building, y = ~hitpoints, color = ~hitpoints, type = 'bar',colors = c('#FAEF95','#B25C23','#9C171F' ),width=1000,height=1000) %>%
  layout(title = 'Buildings by Hitpoints',
         xaxis = list(title = "Building",
                      categoryorder = "array",
                      categoryarray = buildingsarray),
         yaxis = list(title = 'Hitpoints'))


server <- function(input, output) {
  
  datasetInput <- reactive({
    switch(input$variable,
           "Troops" = p,
           "Troops/Housing Space" = p2,
           "Defense" = D,
           "Heros" = H,
           "Buildings" = B)
  })
  
  
  output$plot <- renderPlotly({
    datasetInput()
                      })
    
  
}

# Run the application 
shinyApp(ui = ui, server = server)

