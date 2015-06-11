
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(shiny)
library(DT)


shinyUI(fluidPage(
  titlePanel("MIASOLE FEOL OEE"),

  sidebarLayout(
    sidebarPanel(
      selectInput("type", 
                  label = "Choose a Resource to display",
                  choices = list("ROC", "CTS","WER","YLD"),
                  selected = "ROC"),
      plotOutput("OEEBarChart"),
      tableOutput("statusROC"),
      tableOutput("statusCTS"),
      tableOutput("statusWER")
     
    ),
    mainPanel(
      #verbatimTextOutput("summary"),
      plotOutput("OEEPareto"),
      DT::dataTableOutput("view")
    )
  )
))
