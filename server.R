
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

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
