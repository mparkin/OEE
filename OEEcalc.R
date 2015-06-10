# OEE calculations here
library(lubridate)

OEE.defs<- read.csv("OEEassump.csv") 

runTimeHrs <- function(StartTime, EndTime)
{
  return((EndTime - (ymd_hms(StartTime)))/ ehours(1) )
}


buildOptimal <- function(hours)
{
  df.temp <- OEE.defs[,6:11]
  df.res<-df.temp
  for(i in seq_len(ncol(df.res)))
  {
    df.res[,i] <-df.temp[, i]  * hours
  }
  return(df.res)
}

cellOUtput <- function(df.data)
{
  v.res <-colSums(df.Yield[,3:4])
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
  
}