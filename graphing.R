#place to put graphing functions

library(reshape2)
library(plyr)
library(ggplot2)

#function to plot actual OEE to Ideal OEE bar chart
OEEBarChart <- function(df.data)
{
  df.out <- melt(df.data,id.vars = "DataType")
  ggplot(df.graph,aes(x= variable, y = value, colour = DataType,fill = DataType)) +
    geom_bar(position = 'dodge',stat = "identity")
}

OEEPareto <- function(df.data)
{
  #v.Resource <- unique(df.data[,"Resource"])
  #v.E10 <- unique(df.data[,"E10"])
  #v.E58 <- unique(df.data[,"E58"])
  df.tmp <-ddply(df.data,c("Resource","E10","E58"),function(df.ROC)sum(df.ROC$duration)/3600)
  df.graph <- df.tmp
  ggplot(df.graph,aes(reorder(V1,E10),x= E10, y = V1, colour = Resource,fill = Resource)) +
    geom_bar(position = 'dodge',stat = "identity") +
    facet_grid(Resource ~ .)
}