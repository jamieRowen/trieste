## novelty value with tweenr and gganimate 

library(tweenr)
library(ggplot2)
library(ggplot2movies)
library(gganimate)
library(magrittr)
library(dplyr)
library(tidyr)

data(movies)

## add a decade column
movies %<>% mutate(dec = 10*(year %/% 10))
# grab the years for which there is available data
keys = (movies %>% 
          group_by(dec) %>% 
          count(Action) %>% 
          spread(Action,n) %>% 
          drop_na())$dec
## keep those for which we have data and calculate summary statistics
sub = movies %>% 
  filter(dec %in% keys) %>%
  group_by(dec,Action) %>% 
  summarise(n = n(), 
            length = mean(length),
            rating = mean(rating)) %>%
  ungroup

## make the decade variable a factor, this stops the values being interpolated by tween_states
## later on
sub$dec = as.factor(sub$dec)

# create a list of data frames, one for each decade
## we do this since tween_states takes a list of data frames and interpolates the values between them 
## to give the values for each frame in the animation to give the smooth movement
datlist = split(sub,sub$dec)

## create the collection of interpolated values that will make up the animation frames
tweened = tween_states(datlist,2,1,ease = "cubic-in-out",nframes = 375)

## the gganimate package adds a new aesthetic to each geom in ggplot - frame
## ggplot will give a warning that frame is an unused aesthetic but don't worry 
## gganimate knows what to do
g = ggplot(tweened) + 
  geom_point(aes(x = length, y = rating, size = n, colour = factor(Action), frame = .frame)) + 
  theme_bw() +
  theme(legend.position = "bottom") + 
  scale_size_continuous(guide = FALSE) + 
  scale_color_discrete(name = "Action") + 
  xlab("Length") + 
  ylab("Rating") + 
  ylim(0,10) + 
  geom_text( x = 20, y = 7.5, aes(label = dec, frame = .frame), size = 6)

## where the magic happens, interval says how long between each frame
## this may take a little while to render
gganimate(g,interval = .1, title_frame = FALSE)



## a slightly nicer example using the gapminder population gdp data
library(gapminder)

## same as above, set year to be a factor then create the list of data frames and 
## the interpolated values to make up the frames
gapminder$year = as.factor(gapminder$year)
glist = split(gapminder,gapminder$year)
gapminder_tween = tween_states(glist,2,1,ease="cubic-in-out",nframes = 375)

g = ggplot(gapminder_tween) +
  geom_point(aes(gdpPercap, lifeExp, size = pop, color = continent, frame = .frame),
             alpha = 0.6) +
  scale_x_log10() + 
  geom_text(x=4.5, y = 30, size = 6, aes(label = year, frame = .frame)) +
  theme_bw() + scale_size(range = c(2,12))

gganimate(g,interval = .1, title_frame = FALSE)
