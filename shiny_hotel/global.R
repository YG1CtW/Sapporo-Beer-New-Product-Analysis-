# the necessary packages
library(leaflet)
library(shiny)
library(shinyalert)
library(shinythemes)
library(shinyWidgets)
library(tidyverse)

# input id's of tabs
ti <- c(
  'home', 
  'loca', 
  'acco', 
  'dini', 
  'amen', 
  'attr', 
  'abou'
)

# labels of tabs
tl <- c(
  'Home', 
  'Location', 
  'Accommodations', 
  'Dining', 
  'Amenities', 
  'Attractions', 
  'About Us'
)

# the coordinates of the hotel location
hlat <- -22.963090
hlng <-  14.507755
