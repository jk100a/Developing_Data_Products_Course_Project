library(shiny)
library(data.table)
library(rCharts)

shinyUI(
        navbarPage("NOAA Storm Database",
                   tabPanel("Exploratory Analysis",
                            sidebarPanel(
                                    sliderInput("range",
                                                "Timeline:",
                                                min = 1950,
                                                max = 2011,
                                                value = c(1991, 2011)
                                                # format="####"
                                                ),
                                    uiOutput("evtControls"),
                                    actionButton(inputId = "clearAll", 
                                                 label = "Clear All", 
                                                 icon = icon("square-o")),
                                    actionButton(inputId = "selectAll", 
                                                 label = "Select All", 
                                                 icon = icon("check-square-o"))
                                    ),
                            
                            mainPanel(
                                    tabsetPanel(
                                            tabPanel("Data Set",
                                                     dataTableOutput(outputId = "table")
                                                     ),
                                            tabPanel("Visualization",
                                                     h4("Number of events", align = "center"),
                                                     showOutput("events", "nvd3"),
                                                     h4("Population Impact", align = "center"),
                                                     showOutput("pop.imp", "nvd3"),
                                                     h4("Economic Impact", align = "center"),
                                                     showOutput("eco.imp", "nvd3")
                                                     )
                                            )
                                    )
                            ),
                   
                   tabPanel("About",
                            mainPanel(
                                    includeMarkdown("README.md")
                                    )
                            )
                   )
        )