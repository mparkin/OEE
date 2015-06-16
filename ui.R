
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(shiny)
library(DT)
library(lubridate)
 
 epoch<- "2015-06-01 00:00:00.000"
 endTime<- now()
 starttime <- epoch
 
shinyUI(fluidPage(
  titlePanel("MIASOLE FEOL OEE"),

  sidebarLayout(
    sidebarPanel(
      textInput("starttime", "From:", value = epoch ),
      #textOutput("Start"),
      textInput("endTime", "To:", value = endTime ),
      selectInput("type", 
                  label = "Choose a Resource to display",
                  choices = list("ROC", "CTS","WER","YLD"),
                  selected = "ROC"),
      plotOutput("OEEBarChart"),
      textOutput("rawOEE"),
      textOutput("committedOEE"),
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
