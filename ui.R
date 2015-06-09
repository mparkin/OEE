
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# Load RODBC package
library(RODBC)

library(shiny)
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
