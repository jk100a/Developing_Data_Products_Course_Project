library(shiny)
library(data.table)
library(rCharts)
library(reshape2)
library(markdown)

storm <- fread("storm.csv")
storm$EVTYPE <- tolower(storm$EVTYPE)
evtypes <- sort(unique(storm$EVTYPE))

shinyServer(function(input, output) {
        storm.state <- reactive({
                temp <- merge(data.table(STATE = sort(unique(storm$STATE))),
                              storm[YEAR >= input$range[1] & YEAR <= input$range[2] & EVTYPE %in% input$evtypes,
                                    list(COUNT = sum(COUNT),
                                         INJURIES = sum(INJURIES),
                                         FATALITIES = sum(FATALITIES),
                                         PROPDMG = round(sum(PROPDMG), 2),
                                         CROPDMG = round(sum(CROPDMG), 2)),
                                    by = list(STATE)],
                              by = c('STATE'), all = TRUE
                              )
                temp[is.na(temp)] <- 0
                temp
                })
        
        storm.year <- reactive({storm[YEAR >= input$range[1] & YEAR <= input$range[2] & EVTYPE %in% input$evtypes,
                                      list(COUNT = sum(COUNT),
                                           INJURIES = sum(INJURIES),
                                           FATALITIES = sum(FATALITIES),
                                           PROPDMG = round(sum(PROPDMG), 2),
                                           CROPDMG = round(sum(CROPDMG), 2)),
                                      by = list(YEAR)]
                                })
        
        values <- reactiveValues()
        values$evtypes <- evtypes
        
        output$evtControls <- renderUI({
                if(TRUE) {
                        checkboxGroupInput("evtypes", "Event Types", evtypes,
                                           selected = values$evtypes)
                }
                })
        
        observe({
                if(input$selectAll == 0) return()
                values$evtypes <- evtypes
        })
        
        observe({
                if(input$clearAll == 0) return()
                values$evtypes <- c()
        })
        
        dataTable <- reactive({
                storm.state()[, list(State = state.abb[match(STATE, tolower(state.name))],
                                     Count = COUNT, Injuries = INJURIES, Fatalities = FATALITIES,
                                     Property.damage = PROPDMG, Crops.damage = CROPDMG)]
                })
        
        output$table <- renderDataTable({dataTable()},
                                            options = list(searching = TRUE, pageLength = 25)
                )
        
        output$events <- renderChart2({
                temp <- storm.year()[, list(COUNT = sum(COUNT)), by = list(YEAR)]
                setnames(temp, c("YEAR", "COUNT"), c("Year", "Count"))
                events <- nPlot(Count ~ Year, data = temp[order(temp$Year)],
                                type = "lineChart", width = 700)
                
                events$chart(margin = list(left = 100))
                events$yAxis(axisLabel = "Count", width = 80)
                events$xAxis(axisLabel = "Year", width = 60)
                
                return(events)
                })
        
        output$pop.imp <- renderChart2({
                temp <- melt(storm.year()[, list(Year = YEAR, Injuries = INJURIES,
                                                 Fatalities = FATALITIES)], id = "Year")
                pop.imp <- nPlot(value ~ Year, group = "variable",
                                 data = temp[order(-Year, variable, decreasing = TRUE)],
                                 type = "stackedAreaChart", width = 700)
                
                pop.imp$chart(margin = list(left = 100))
                pop.imp$yAxis(axisLabel = "Affected Population", width = 80)
                pop.imp$xAxis(axisLabel = "Year", width = 60)
        
                return(pop.imp)
                })
        
        output$eco.imp <- renderChart2({
                temp <- melt(storm.year()[, list(Year = YEAR, Propety = PROPDMG, Crops = CROPDMG)],
                             id = "Year")
                eco.imp <- nPlot(value ~ Year, group = "variable",
                                 data = temp[order(-Year, variable, decreasing = TRUE)],
                                 type = "stackedAreaChart", width = 700)
                
                eco.imp$chart(margin = list(left = 100))
                eco.imp$yAxis(axisLabel = "Total Damage ($ in Million)", width = 80)
                eco.imp$xAxis(axisLabel = "Year", width = 60)
                
                return(eco.imp)
                })
        })