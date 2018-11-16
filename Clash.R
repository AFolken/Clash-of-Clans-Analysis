library(plotly)
library(readxl)
clash <- read_excel("H:/My Documents/clash.xlsx",sheet = "Sheet3")
#elixir costs were increase by two orders of magnitude for Dark Elixir(DE), to account for the rarity of DE.
clash$cost2 <- clash$cost/clash$housing
clash$damage_per_second2 <- clash$damage_per_second/clash$housing
clash$hitpoints2 <- clash$hitpoints/clash$housing


p <- plot_ly(clash, x = ~damage_per_second, y = ~hitpoints, z = ~cost, color = ~troop, colors = c('#BF382A', '#0C4B8E')) %>%
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

p2 <- plot_ly(clash, x = ~damage_per_second2, y = ~hitpoints2, z = ~cost2, color = ~troop) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'damage/second'),
                      yaxis = list(title = 'hitpoints'),
                      zaxis = list(title = 'cost')))

p2
