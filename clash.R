rm(list = ls())
library(plotly)
library(readxl)
library(tidyverse)

clash_troops <- read_excel("H:/My Documents/clash.xlsx",sheet = "Troops")
clash_defense <- read_excel("H:/My Documents/clash.xlsx",sheet = "Defense")
clash_heros <- read_excel("H:/My Documents/clash.xlsx",sheet = "Heros")
clash_buildings <- read_excel("H:/My Documents/clash.xlsx",sheet = "Buildings")


#elixir costs were increase by two orders of magnitude for Dark Elixir(DE), to account for the rarity of DE.

#here I am dividing cost, damage, and hitpoints by housing space. Some troops take up more space than others so I thought it would be interesting to see.
clash_troops$cost2 <- clash_troops$cost/clash_troops$housing
clash_troops$damage_per_second2 <- clash_troops$damage_per_second/clash_troops$housing
clash_troops$hitpoints2 <- clash_troops$hitpoints/clash_troops$housing


p <- plot_ly(clash_troops, x = ~damage_per_second, y = ~hitpoints, z = ~cost, color = ~troop, colors = c('#BF382A', '#0C4B8E')) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'Damage/Second'),
                      yaxis = list(title = 'Hitpoints'),
                      zaxis = list(title = 'Cost')))

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
#chart_link = api_create(p, filename="scatter3d-basic")
#chart_link

p


#features including a 2 are calculated out of housing space required

p2 <- plot_ly(clash_troops, x = ~damage_per_second2, y = ~hitpoints2, z = ~cost2, color = ~troop) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'Damage/Second'),
                      yaxis = list(title = 'Hitpoints'),
                      zaxis = list(title = 'Cost')))

p2

#buildings
D <- plot_ly(clash_defense, x = ~damage_per_second, y = ~hitpoints, z = ~Range, color = ~building, colors = c('#BF382A', '#0C4B8E')) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'Damage/Second'),
                      yaxis = list(title = 'Hitpoints'),
                      zaxis = list(title = 'Range')))
D

h <- plot_ly(clash_heros, x = ~damage_per_second, y = ~hitpoints, z = ~Range, color = ~hero, colors = c('#BF382A', '#0C4B8E')) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'Damage/Second'),
                      yaxis = list(title = 'Hitpoints'),
                      zaxis = list(title = 'Range')))

h

buildingslist <- arrange(clash_buildings, -hitpoints)
buildingsarray <- as.array(buildingslist$building)

B <- plot_ly(clash_buildings, x = ~building, y = ~hitpoints, color = ~hitpoints, type = 'bar',colors = c('#FAEF95','#B25C23','#9C171F' )) %>%
  layout(title = 'Buildings by Hitpoints',xaxis = list(title = "Building",
                                   categoryorder = "array",
                                   categoryarray = buildingsarray),
                      yaxis = list(title = 'Hitpoints'))

B