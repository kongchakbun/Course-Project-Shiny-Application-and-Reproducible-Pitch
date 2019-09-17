library(shiny)
library(quantmod)
library(dplyr)
library(ggplot2)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Monthly Hang Seng Index and Dwon Jones Ind. Ave. Index Levels"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("yearNo",
                   "Number of Years of Data to Show:", min = 1, max = 10, value = 1),
        checkboxInput("showHSIVol", "Show/Hide HSI Volatility", value = TRUE),
        checkboxInput("showDJIVol", "Show/Hide DJI Volatility", value = TRUE),
       numericInput("yearok", "Number of Years Showing the Correlations", min = 1, max = 10, value = 1)
    ),
    
    # Show a plot of index movement
    mainPanel(
       plotOutput("distPlot"),
       h4("Annualized HSI Monthly Return Volatility in 10 Years:"),
       textOutput("HSIVol"),
       h4("Annualized DJI Monthly Return volatility in 10 Years:"),
       textOutput("DJIVol"),
       h4("Correlation between HSI and DJI within Period Concerned:"),
       textOutput("correlation")
       
    )
  )
))
