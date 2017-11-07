library(shiny)
library(leaflet)
library(dplyr)
library(datasets)
library(ggplot2)

shinyUI(fluidPage(
    titlePanel("Frequency of Earthquakes (from R dataset 'quakes')"),
    sidebarLayout(
        sidebarPanel(
            h5("Input 2 different earthquake magnitudes to compare frequency data"),
            h2("Magnitude High"),
            sliderInput("magHi" ,"Enter Larger Magnitude", min = 4, max =  6.4, value = 5.5, step = .1),
            h2("Magnitude Low"),
            sliderInput("magLo" ,"Enter Smaller Magnitude", min = 4, max =  6.4, value = 4.5, step = .1),
            submitButton("Submit"),
            h2(textOutput("frequency"))
        ),
        mainPanel(
            h3("Map of earthquakes near Fiji from 1964"),
            leafletOutput("plot1"),
            plotOutput("plot2")
            ))
        )
)


