rm(list = ls())
library(plotly)
library(readxl)
clash_troops <- read_excel("H:/My Documents/clash.xlsx",sheet = "Troops")
clash_buildings <- read_excel("H:/My Documents/clash.xlsx",sheet = "Defense")
clash_heros <- read_excel("H:/My Documents/clash.xlsx",sheet = "Heros")

#elixir costs were increase by two orders of magnitude for Dark Elixir(DE), to account for the rarity of DE.
clash_troops$cost2 <- clash_troops$cost/clash_troops$housing
clash_troops$damage_per_second2 <- clash_troops$damage_per_second/clash_troops$housing
clash_troops$hitpoints2 <- clash_troops$hitpoints/clash_troops$housing


p <- plot_ly(clash_troops, x = ~damage_per_second, y = ~hitpoints, z = ~cost, color = ~troop, colors = c('#BF382A', '#0C4B8E')) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'damage/second'),
                      yaxis = list(title = 'hitpoints'),
                      zaxis = list(title = 'cost')))

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
#chart_link = api_create(p, filename="scatter3d-basic")
#chart_link

p


#features including a 2 are calculated out of housing space required

p2 <- plot_ly(clash_troops, x = ~damage_per_second2, y = ~hitpoints2, z = ~cost2, color = ~troop) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'damage/second'),
                      yaxis = list(title = 'hitpoints'),
                      zaxis = list(title = 'cost')))

p2

#buildings
B <- plot_ly(clash_buildings, x = ~damage_per_second, y = ~hitpoints, z = ~Range, color = ~building, colors = c('#BF382A', '#0C4B8E')) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'damage/second'),
                      yaxis = list(title = 'hitpoints'),
                      zaxis = list(title = 'range')))
B

h <- plot_ly(clash_heros, x = ~damage_per_second, y = ~hitpoints, z = ~Range, color = ~hero, colors = c('#BF382A', '#0C4B8E')) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'damage/second'),
                      yaxis = list(title = 'hitpoints'),
                      zaxis = list(title = 'range')))

h