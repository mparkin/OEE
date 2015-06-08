
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
dataframe <- sqlQuery(channel, "SELECT * FROM DW.dbo.f_ResourceHistory WHERE StartTime > (GETUTCDATE() - 1)")
# close ODBC connection!!!
odbcClose(channel)

shinyUI(fluidPage(

  # Application title
  titlePanel("Old Faithful Geyser Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
