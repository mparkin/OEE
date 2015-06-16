
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(DT)
library(lubridate)

source("DataAccess.R" )
source("graphing.R")
source("OEEcalc.R")

epoch<- "2015-06-01 00:00:00.000"    
endTime<- now()
starttime <- epoch




shinyServer(function(input, output) {
 
   OEE.defs <- read.csv("OEEassump.csv")   
   intstart <- reactive({
     input$starttime
   })
   # main screen output data table
   output$view <- DT::renderDataTable({
     if(input$type != "YLD")
     {
       getdbdata()  
     }else {
       getYielddata(input$starttime,input$endTime)
     }
     
   })

   getdbdata<- function()
   {
     return (getResourcedata(input$starttime,input$type,input$endTime))
   }

   getOEEData <- function()
   {
     df.OEEdata <- buildOptimal(runTimeHrs(input$starttime,input$endTime))
     df.OEEdata <- buildcellout(cellOUtput(getYielddata(input$starttime,input$endTime)),df.OEEdata)
     return (df.OEEdata)
   }
  
 
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  # OEE numbers to screen
  #output$rawOEE <- renderText({paste("Raw Watts OEE", df.OEEdata[3,3])})
  #output$committedOEE <- renderText({paste("Committed Watts OEE",df.OEEdata[3,6])})
  # show table
  output$OEEBarChart <- renderPlot({
    OEEBarChart(getOEEData())
  })
  output$OEEPareto <- renderPlot({
    if(input$type != "YLD")
    {
      OEEPareto(getdbdata())  
    }else {
      OEEPareto(getYielddata(input$starttime,input$endTime))
    }
    
  })
  # show status
  output$statusROC <- renderTable({
    df.tmp <- getdbdata()
    res.list <-unique(df.tmp[,1])
    
    df.tmp[order(df.tmp[,7]),][,c("Resource","E10")][(nrow(df.tmp)-nlevels(unique(df.tmp[,1]))+1):nrow(df.tmp),]
  })

})
