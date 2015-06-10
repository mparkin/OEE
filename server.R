
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(DT)
source("DataAccess.R" )

df.ROC<-getResourcedata("2015-06-01 00:00:00.000","ROC")
df.CTS<-getResourcedata("2015-06-01 00:00:00.000","CTS")
df.WER<-getResourcedata("2015-06-01 00:00:00.000","WER")
df.Yield <- getYielddata("2015-06-01 00:00:00.000","ROC03")

# close ODBC connection!!!
#odbcClose(channel)
RCIDs<-unique(df.ROC[,1],)
CTSIDs<-unique(df.CTS[,1],)
WERIDs<-unique(df.WER[,1],)

shinyServer(function(input, output) {
  # Return the requested dataset

  datasetInput <- reactive({
    switch(input$type,
           "ROC" = df.ROC,
           "CTS" = df.CTS,
           "WER" = df.WER,
           "YLD" = df.Yield)
  })
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  # show table
  output$view <- DT::renderDataTable({
    datasetInput()
  })
  output$OEEBarChart <- renderPlot({
    OEEBarChart(df.OEEdata)
  })
  # show status
  output$statusROC <- renderTable({
    df.ROC[order(df.ROC[,7]),][,c("Resource","E10")][(nrow(df.ROC)-nlevels(RCIDs)+1):nrow(df.ROC),]
  })
  output$statusCTS <- renderTable({
    df.CTS[order(df.CTS[,7]),][,c("Resource","E10")][(nrow(df.CTS)-nlevels(CTSIDs)+1):nrow(df.CTS),]
  })
  output$statusWER <- renderTable({
    df.WER[order(df.WER[,7]),][,c("Resource","E10")][(nrow(df.WER)-nlevels(WERIDs)+1):nrow(df.WER),]
  })

})
