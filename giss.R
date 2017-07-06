# Set working directory, get data, load libraries
# setwd("C:/path/to/folder") # Uncomment this to set your working directory.
giss.avg  <-read.csv("https://data.giss.nasa.gov/gistemp/tabledata_v3/GLB.Ts+dSST.csv",    stringsAsFactors=F, skip=1)
library(ggplot2)
library(reshape2)
library(lubridate)
library(scales)
library(viridis)

# Tidy up Average dataset
giss.avg<-giss.avg[,1:13]
giss.avg<-melt(giss.avg, id="Year")
giss.avg$value<-as.numeric(giss.avg$value)
giss.avg$date<-as.Date(paste(giss.avg$Year, giss.avg$variable, "01"), "%Y %b %d")

# Plot the Average dataset
ggplot(giss.avg, aes(y=month(date), x=year(date)))+
  geom_tile(aes(fill=value))+
  scale_fill_viridis(option="inferno")+
  scale_y_reverse(breaks=1:12, labels=strftime(paste("0001-",1:12,"-01",sep=""), "%b"))+
  scale_x_continuous(breaks=seq(1880, 2020, 10))+
  labs(title="Global Temperature Anomaly",
       subtitle="source: https://data.giss.nasa.gov/gistemp/",
       x="",y="",
       fill="Difference\nFrom Mean\n(deg. C)",
       caption="created by /u/zonination")+
  theme_bw()+
  theme(panel.grid.minor = element_blank())
ggsave("giss-avg.png", height=5, width=12.5, dpi=120, type="cairo-png")
