
library(RODBC)

epoch<- "2015-06-01 00:00:00.000"
resourceTypes<- c("ROC","CTS","WER")
getResourcedata = function(startDate, Res)
{
  #Create a connection to the database called "channel"
  channel <- odbcConnect("mia4","fis","fis")

  # Check that connection is working (Optional)
  # odbcGetInfo(channel) #debug stuff
  # Find out what tables are available (Optional)
  # Tables <- sqlTables(channel, "DW") #debug stuff
  
  sqlcmd <- paste("SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE ResourceType = '", Res , "' AND StartTime >= '", startDate,"'", sep = "" )
  # Query the database and put the results into the data frame "dataframe"
  df.OUT <- sqlQuery(channel, sqlcmd)

  # close ODBC connection!!!
  odbcClose(channel)
  return(df.OUT)
}

getYielddata = function(startDate,Res)
{
  #Create a connection to the database called "channel"
  channel <- odbcConnect("mia4","fis","fis")
  
  # Check that connection is working (Optional)
  # odbcGetInfo(channel) #debug stuff
  # Find out what tables are available (Optional)
  # Tables <- sqlTables(channel, "DW") #debug stuff
  
  # sqlcmd <- paste("select TestTime, CoaterTime,CellTested, CellPassed, Grade, VisionTested, VisionPassed, DTStamp, Coater, Weaver,Tester from DW.dbo.f_FEOLCellVision WHERE Coater = '", Res , "' AND CoaterTime >= '", startDate,"'", sep = "" )
  sqlcmd <- paste("select TestTime, CoaterTime,CellTested, CellPassed, Grade, VisionTested, VisionPassed, DTStamp, Coater, Weaver,Tester from DW.dbo.f_FEOLCellVision WHERE CoaterTime >= '", startDate,"'", sep = "" )
  #df.Yield <- sqlQuery(channel, "select TestTime, CoaterTime,CellTested, CellPassed, Grade, VisionTested, VisionPassed, DTStamp, Coater, Weaver from DW.dbo.f_FEOLCellVision WHERE Owner = 'MFG' and Coater = 'ROC03' AND CoaterTime > '2015-06-01 00:00:00.000'")

  # Query the database and put the results into the data frame "dataframe"
  df.OUT <- sqlQuery(channel, sqlcmd)

  # close ODBC connection!!!
  odbcClose(channel)
  return(df.OUT)
  
}
