Developing Data Products Course Project
NOAA Storm Database
=======================================
author: Yao Zhang
date: 05/23/2015

Shiny App
=======================================
This presentation is part of the course project of [Developing Data Products](https://www.coursera.org/course/devdataprod) provided by Coursera.

In the project, students are asked to:

- Use **shiny** to create a web application
- Use **RStudio Presenter** or **slidify** to create reproducible pitch presentation

Storm Data Set
========================================================
The data set used is based on the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database which can be obtained from [this link](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2).

It is the same data set that used for another course projrct of [Reproducible Research](https://www.coursera.org/course/repdata) provided by Coursera.

- The deployed Shiny App can be found [here](https://jk100a.shinyapps.io/project/).

- The source code for the project is available on [Github](https://github.com/jk100a/Developing_Data_Products_Course_Project).

How to Use
========================================================
The deployed Shiny App allows users to:

1. Adjust `Timeline` by dragging the slide bar.
2. Select different `Event Types` by checking the boxes in the control panel located on the left side of the web page. You can also `Select All` or `Clear All` the event types.
3. The result is shown in the main pannel on the right side of the web page. Under the `Data Set` tab, You can filter the data set to get the information you're interested. Under the `Visualization` tab, you can see some interactive plots. Feel free to change the input values and obeserve how the output values change along with it.

Head of the Data
========================================================

```r
storm <- read.csv("storm.csv")
head(storm, 3)
```

```
  YEAR   STATE  EVTYPE COUNT FATALITIES INJURIES PROPDMG CROPDMG
1 1950 alabama TORNADO     2          0       15  0.0275       0
2 1951 alabama TORNADO     5          0       13  0.0350       0
3 1952 alabama TORNADO    13          6      116  5.4525       0
```
