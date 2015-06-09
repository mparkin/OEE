
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(DT)
source("DataAccess.R" )

#getdbdata("2015-06-01 00:00:00.000'")
#Create a connection to the database called "channel"
channel <- odbcConnect("mia4","fis","fis")

# Check that connection is working (Optional)
odbcGetInfo(channel)
#df.ROC <- sqlQuery(channel, "SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE StartTime >= DATEADD(day, -1, GETDATE()) AND ResourceType = 'ROC'")
#df.CTS <- sqlQuery(channel, "SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE StartTime >= DATEADD(day, -1, GETDATE()) AND ResourceType = 'CTS'")
#df.WER <- sqlQuery(channel, "SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE StartTime >= DATEADD(day, -1, GETDATE()) AND ResourceType = 'WER'")
#df.Yield <- sqlQuery(channel, "select * from DW.dbo.f_FEOLCellVision WHERE Owner = 'MFG' and Coater = 'ROC03' AND CoaterTime > '2015-06-01 00:00:00.000'")
df.ROC <- sqlQuery(channel, "SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE StartTime >= '2015-06-01 00:00:00.000' AND ResourceType = 'ROC'")
df.CTS <- sqlQuery(channel, "SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE StartTime >= '2015-06-01 00:00:00.000' AND ResourceType = 'CTS'")
df.WER <- sqlQuery(channel, "SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE StartTime >= '2015-06-01 00:00:00.000' AND ResourceType = 'WER'")
df.Yield <- sqlQuery(channel, "select TestTime, CoaterTime,CellTested, CellPassed, Grade, VisionTested, VisionPassed, DTStamp, Coater, Weaver from DW.dbo.f_FEOLCellVision WHERE Owner = 'MFG' and Coater = 'ROC03' AND CoaterTime > '2015-06-01 00:00:00.000'")

# close ODBC connection!!!
odbcClose(channel)

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
  
  # Show the first "n" observations
  output$view <- DT::renderDataTable({
    datasetInput()
  })
})
