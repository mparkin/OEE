
library(RODBC)

epoch<- "2015-06-01 00:00:00.000"
resourceTypes<- c("ROC","CTS","WER")
getResourcedata = function(startDate, Res)
{
  #Create a connection to the database called "channel"
  channel <- odbcConnect("mia4","fis","fis")
  
  sqlcmd <- paste("SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE ResourceType = '", Res , "' AND StartTime >= '", startDate,"'", sep = "" )
  # Query the database and put the results into the data frame "dataframe"
  df.OUT <- sqlQuery(channel, sqlcmd)
  df.OUT <- transform(df.OUT,duration = as.double(ymd_hms(EndTime)-ymd_hms(StartTime)))

  # close ODBC connection!!!
  odbcClose(channel)
  return(df.OUT)
}

getYielddata = function(startDate)
{
  #Create a connection to the database called "channel"
  channel <- odbcConnect("mia4","fis","fis")
  
  sqlcmd <- paste("select TestTime, CoaterTime,CellTested, CellPassed, Grade, VisionTested, VisionPassed, DTStamp, Coater, Weaver,Tester from DW.dbo.f_FEOLCellVision WHERE CoaterTime >= '", startDate,"'", sep = "" )
 
  # Query the database and put the results into the data frame "dataframe"
  df.OUT <- sqlQuery(channel, sqlcmd)

  # close ODBC connection!!!
  odbcClose(channel)
  return(df.OUT)
  
}
