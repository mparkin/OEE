
library(RODBC)


getdbdata = function(startDate, Res)
{
  #Create a connection to the database called "channel"
  channel <- odbcConnect("mia4","fis","fis")

  # Check that connection is working (Optional)
  odbcGetInfo(channel)

  # Find out what tables are available (Optional)
  Tables <- sqlTables(channel, "DW")
  #sqlcmd <- paste("SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE ResourceType = 'ROC' AND StartTime >= ", startDate, sep = "" )
  # Query the database and put the results into the data frame "dataframe"
  df.ROC <- sqlQuery(channel, "SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE StartTime >= DATEADD(day, -1, GETDATE()) AND ResourceType = 'ROC'")
  df.CTS <- sqlQuery(channel, "SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE StartTime >= DATEADD(day, -1, GETDATE()) AND ResourceType = 'CTS'")
  df.WER <- sqlQuery(channel, "SELECT Resource, E10, E58, Reason, Availability, StartTime, EndTime FROM DW.dbo.f_ResourceHistory WHERE StartTime >= DATEADD(day, -1, GETDATE()) AND ResourceType = 'WER'")
  df.Yield <- sqlQuery(channel, "select * from DW.dbo.f_FEOLCellVision WHERE Owner = 'MFG' and Coater = 'ROC03' AND CoaterTime > '2015-06-01 00:00:00.000'")

  # close ODBC connection!!!
  odbcClose(channel)
}
