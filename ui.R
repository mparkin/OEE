
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(shiny)


shinyUI(fluidPage(
  titlePanel("MIASOLE FACTORY OEE"),

  sidebarLayout(
    sidebarPanel(
      selectInput("type", 
                  label = "Choose a Resource to display",
                  choices = list("ROC", "CTS","WER"),
                  selected = "ROC")
    ),
    mainPanel(
      verbatimTextOutput("summary"),
      tableOutput("view")
    )
  )
))
