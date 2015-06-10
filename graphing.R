#place to put graphing functions

library(reshape2)
library(ggplot2)

#function to plot actual OEE to Ideal OEE bar chart
OEEBarChart <- function(df.data)
{
  df.out <- melt(df.data,id.vars = "DataType")
  ggplot(df.graph,aes(x= variable, y = value, colour = DataType,fill = DataType)) +
    geom_bar(position = 'dodge',stat = "identity")
}