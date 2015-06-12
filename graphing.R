#place to put graphing functions

library(reshape2)
library(plyr)
library(ggplot2)
library(reshape)

#function to plot actual OEE to Ideal OEE bar chart
OEEBarChart <- function(df.data)
{
  df.graph <- melt(df.data,id.vars = "DataType")
  ggplot(df.graph,aes(x= variable, y = value, colour = DataType,fill = DataType)) +
    geom_bar(position = 'dodge',stat = "identity")
}

OEEPareto <- function(df.data)
{
  if(colnames(df.data)[1] == "Resource")
  { 

    df.graph <-ddply(df.data,c("Resource","E10","E58"),function(df.graph)sum(df.graph$duration)/3600)
    ggplot(df.graph,aes(reorder(V1,E10),x= E10, y = V1, colour = Resource,fill = Resource)) +
      geom_bar(position = 'dodge',stat = "identity") +
      facet_grid(Resource ~ .)
  }
  else
  {
    df.tmp<-melt(df.data, id = "Grade", "CellTested")
    df.graph<-cast(df.tmp,Grade~variable,sum)
    ggplot(data=df.graph, aes(x=Grade, y=CellTested),colour = Grade, fill = Grade) +
      geom_bar(stat="identity",colour = "Red", fill = "Blue")
    
  }
}