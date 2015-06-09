
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(RODBC)

#Create a connection to the database called "channel"
channel <- odbcConnect("mia4","fis","fis")

# Check that connection is working (Optional)
odbcGetInfo(channel)

# Find out what tables are available (Optional)
Tables <- sqlTables(channel, "DW")

# Query the database and put the results into the data frame "dataframe"
df.ROC <- sqlQuery(channel, "SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE StartTime >= DATEADD(day, -1, GETDATE()) AND ResourceType = 'ROC'")
df.CTS <- sqlQuery(channel, "SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE StartTime >= DATEADD(day, -1, GETDATE()) AND ResourceType = 'CTS'")
df.WER <- sqlQuery(channel, "SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE StartTime >= DATEADD(day, -1, GETDATE()) AND ResourceType = 'WER'")


# close ODBC connection!!!
odbcClose(channel)



shinyServer(function(input, output) {
  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$type,
           "ROC" = df.ROC,
           "CTS" = df.CTS,
           "WER" = df.WER)
  })
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  # Show the first "n" observations
  output$view <- renderTable({
    head(datasetInput(),n = 10)
  })
})
