# OEE calculations here
library(lubridate)

OEE.defs<- read.csv("OEEassump.csv") 

runTimeHrs <- function(StartTime, EndTime)
{
  return((ymd_hms(EndTime) - (ymd_hms(StartTime)))/ ehours(1))
}


buildOptimal <- function(hours)
{
  df.temp <- OEE.defs[,6:11]
  df.res<-df.temp
  for(i in seq_len(ncol(df.res)))
  {
    df.res[,i] <-df.temp[, i]  * hours
  }
  colnames(df.res) <- c("OEESheets","OEECells","OEEWatts","YldOEESheets","YldOEECells","YldOEEWatts")
  return(df.res)
}

cellOUtput <- function(df.data)
{
  v.res <-colSums(df.data[,3:4])
  return (v.res)
}

buildcellout <- function(v.cellYield, df.OEEdata)
{
  
  df.OEEdata[2,1]<- 0
  df.OEEdata[2,2]<- v.cellYield[1]
  df.OEEdata[2,3]<- v.cellYield[1] * OEE.defs[1,4]
  df.OEEdata[2,4]<- 0
  df.OEEdata[2,5]<- v.cellYield[2] 
  df.OEEdata[2,6]<- v.cellYield[2] * OEE.defs[1,4]
  a.vector <- c("Ideal","Actual")
  df.OEEdata[,"DataType"]<- a.vector
  df.OEEdata[3,3]<- df.OEEdata[2,3] / df.OEEdata[1,3]
  df.OEEdata[3,2]<- df.OEEdata[2,2] / df.OEEdata[1,2]
  df.OEEdata[3,5]<- df.OEEdata[2,5] / df.OEEdata[1,5]
  df.OEEdata[3,6]<- df.OEEdata[2,6] / df.OEEdata[1,6]
  
  return(df.OEEdata) 
}
