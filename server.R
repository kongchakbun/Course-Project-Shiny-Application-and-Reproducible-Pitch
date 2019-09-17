library(shiny)
library(quantmod)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output) {

        #download the data
        from.dat <- as.Date("09/01/09", format = "%m/%d/%y")
        to.dat <- as.Date("08/31/19", format = "%m/%d/%y")
        suppressWarnings(getSymbols("^HSI", src = "yahoo", from = from.dat, to =to.dat))
        suppressWarnings(getSymbols("^DJI", src = "yahoo", from = from.dat, to =to.dat))
        suppressWarnings(mHSI <- to.monthly(HSI)) 
        suppressWarnings(mDJI <- to.monthly(DJI))
        HSIClose <- Cl(mHSI)
        DJIClose <- Cl(mDJI)
        
        #create time series
        ts1 <- ts(HSIClose, frequency = 12)
        ts2 <- ts(DJIClose, frequency = 12)
        
        #combine the time series data
        stocks <- cbind(as.data.frame(ts1), as.data.frame(ts2))
        
        #calculate the monthly return of the HSI and DJI
        HSIMReturn <- NULL
        DJIMReturn <- NULL
        for (i in 2:nrow(stocks)){HSIMReturn[i-1] <- (stocks[i,1]- stocks[i-1, 1])/stocks[i-1,1]}
        for (i in 2:nrow(stocks)){DJIMReturn[i-1] <- (stocks[i,2]- stocks[i-1, 2])/stocks[i-1,2]}
        
        #calculate the standard deviations
        HSIVol <- sd(HSIMReturn)*sqrt(12)
        DJIVol <- sd(DJIMReturn)*sqrt(12)
        
        #change the column names
        colnames(stocks) <- c("HSI", "DJI")
        
        #add the time period in the data frame.
        stocks <- mutate(stocks, time = rep(as.Date(time(mHSI))))
        
        
  output$distPlot <- renderPlot({
          #check the slider input
          yearNo <- input$yearNo
          
          #create data starting period
          yearData <- nrow(stocks) - yearNo * 12 + 1
          
          #select the data based on the slider input
          stocks <- stocks[yearData:nrow(stocks), ]

          #plot the graph
          g <- ggplot(stocks, aes(time))
          g <- g + geom_line(aes(y=HSI, colour = "HSI")) + geom_line(aes(y = DJI, color = "DJI"))
          g <- g + xlab("Year") + ylab("HSI and DJI Index Level") + ggtitle("HSI and DJI Index Level")
          g
  })
        output$HSIVol <- renderText({
                if(input$showHSIVol){
                  HSIVol}
        })
        output$DJIVol <- renderText({
               if(input$showDJIVol){
                       DJIVol}
       })
        output$correlation <- renderText({
                #check the slider input
                yearok <- input$yearok
                
                #create data starting period
                yearData1 <- nrow(stocks) - yearok * 12 + 1
                
                #select the data based on the slider input
                stocks <- stocks[yearData1:nrow(stocks), ]
                
                correlation <- cor(stocks[, 1], stocks[, 2])
        })
})