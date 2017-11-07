library(shiny)
library(leaflet)
library(dplyr)
library(datasets)
library(ggplot2)

shinyServer(function(input, output) {
    data(quakes)
    quakes <- quakes

##output of comparative frequency of quake magnitudes
    output$frequency <- reactive({
        mult <- round(sum(quakes$mag >= input$magLo)/sum(quakes$mag >= input$magHi),1)
        paste("Earthqakes with magnitude", input$magLo, "or greater were observed",
              mult, "times as often as earthquakes of", input$magHi, "magnitude or greater")
    })

##leaflet plot
    output$plot1 <- renderLeaflet({
        mapDat <- mutate(quakes, magCol = ifelse(mag >= input$magHi, "red",
                                                 ifelse(mag >= input$magLo, "orange", "blue")),
                                 magOp = ifelse(mag >= input$magHi, 1,
                                                ifelse(mag >= input$magLo, .5, .15)))

        legLabels <- c(paste(">=", input$magHi),
                       paste(input$magLo, "to", input$magHi - .1),
                       paste("4.0 to", input$magLo - .1))

        mapDat %>%
            leaflet() %>%
            addTiles() %>%
            addCircleMarkers(radius = 1.7^mapDat$mag,
                             color = mapDat$magCol,
                             stroke = FALSE,
                             fillOpacity = mapDat$magOp) %>%
            addLegend(position = "topright",
                      labels = legLabels,
                      colors = c("red", "yellow", "blue"),
                      title = "Magnitude")
    })
##ggplot histogram
    output$plot2 <- renderPlot ({
        quakeH <- mutate(quakes, magCol = ifelse(mag >= input$magHi, "red",
                                                 ifelse(mag >= input$magLo, "orange", "blue")))

        quakeH$magCol <- as.factor(quakeH$magCol)

        ggplot(quakeH, aes(mag, fill=magCol)) +
            geom_histogram(color="black", binwidth=.1) +
            scale_fill_manual(values = c("blue", "orange", "red"),
                              name = "Magnitude",
                              breaks = c("red", "orange", "blue"),
                              labels = c(paste(">=", input$magHi),
                                         paste(input$magLo, "to", input$magHi - .1),
                                         paste("4.0 to", input$magLo - .1))) +
            xlab("Magnitude") + ylab("Number of Observed Earthquakes") +
            ggtitle("Distribution of Earthquake Magnitudes") +
            theme(plot.title = element_text(hjust = 0.5))
    })
})
