library(ggplot2)
data(movies, package = "ggplot2movies")

## this is the package that allows you to view the different colour palettes
library(RColorBrewer)
display.brewer.all()


## the code below has some options commented out which can be changed around to 
## see the different options for discrete colour scales
g1 = ggplot(movies, aes(x = length, y = rating)) + 
  geom_point(aes(colour = factor(mpaa))) + 
  scale_color_brewer(palette = "Set3")
  # scale_color_manual(values = c("red","blue"))

  

## as above but different options for continuous colour scales
g1 = ggplot(movies, aes(x=length, y = rating)) + 
  geom_point(aes(colour = rating)) + 
  scale_color_gradientn(colours = rainbow(5))
# scale_colour_gradient(low = "blue", high = "red")
# scale_color_gradient2(low = "black", 
#                       high = "red",
#                       mid = "white") + 

g2 = ggplot(movies, aes(x = length, y = rating)) + 
  geom_point(aes(colour = rating)) +
  scale_color_gradient2(low = "black",
                        high = "red",
                        mid = "white")

g3 = ggplot(movies, aes(x = rating)) + 
  geom_histogram()

g4 = ggplot(movies, aes(x = year)) + 
  stat_summary(aes(y = length), fun.y = mean)

library(gridExtra)

## grid.arrange from the grid extra package can be used for laying out multiple distinct plots
## on a single page. Remember if you want numerous plots that are of the same type you can use
## facet_wrap and facet_grid
grid.arrange(g1,g2,g3,g4, ncol = 2)
