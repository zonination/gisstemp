# Set working directory, get data, load libraries
# setwd("C:/path/to/folder") # Uncomment this to set your working directory.
giss.zonal<-read.csv("https://data.giss.nasa.gov/gistemp/tabledata_v3/ZonAnn.Ts+dSST.csv", stringsAsFactors=F)
library(ggplot2)
library(reshape2)
library(lubridate)
library(scales)
library(viridis)

# Tidy up the data
giss.zonal<-giss.zonal[,c(1,8:15)]
giss.zonal<-melt(giss.zonal, id="Year")
giss.zonal$variable<-as.character(giss.zonal$variable)
# Rename the "variable" column to a more legible format
giss.zonal$variable[giss.zonal$variable=="X64N.90N"] <- "90N - 64N"
giss.zonal$variable[giss.zonal$variable=="X44N.64N"] <- "64N - 44N"
giss.zonal$variable[giss.zonal$variable=="X24N.44N"] <- "44N - 24N"
giss.zonal$variable[giss.zonal$variable=="EQU.24N"] <- "24N - 0N"
giss.zonal$variable[giss.zonal$variable=="X24S.EQU"] <- "0S - 24S"
giss.zonal$variable[giss.zonal$variable=="X44S.24S"] <- "24S - 44S"
giss.zonal$variable[giss.zonal$variable=="X64S.44S"] <- "44S - 64S"
giss.zonal$variable[giss.zonal$variable=="X90S.64S"] <- "64S - 90S"
# Order the "variable" column factors
giss.zonal$variable <- factor(giss.zonal$variable, levels = rev(c(
  "90N - 64N","64N - 44N", "44N - 24N", "24N - 0N",
  "0S - 24S", "24S - 44S", "44S - 64S", "64S - 90S")))

ggplot(giss.zonal, aes(x=Year, y=variable))+
  geom_tile(aes(fill=value))+
  scale_fill_viridis(option="inferno",
                     limits=c(min(giss.avg$value, na.rm=T), max(giss.avg$value, na.rm=T)),
                     oob=squish)+
  scale_x_continuous(breaks=seq(1880, 2020, 10))+
  labs(title="Global Temperature Anomaly",
       subtitle="source: https://data.giss.nasa.gov/gistemp/",
       x="",y="Latitude",
       fill="Difference\nFrom Mean\n(deg. C)",
       caption="created by /u/zonination")+
  theme_bw()
ggsave("giss-zonal.png", height=5, width=12.5, dpi=120, type="cairo-png")