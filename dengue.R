## set working directory
setwd("~/Documents/Python-Projects/dengue")

## read dengue csv into dataframe
cases<-read.csv("dengue.csv", colClasses="character")

## set column names
colnames(cases)<- c("year","week","state","city","address","cases","duration")
cases<-cases[,1:7]
dim(cases)
##subset cases
subcases<-cases[sample(nrow(cases), 300), ]

## make a new data columns with start and stop dates
library(lubridate)
subcases$start<-as.Date(paste(subcases$year,"01","01",sep="-")) + as.numeric(subcases$week)*7
subcases$end<- subcases$start + as.numeric(subcases$duration)
subcases$month<-month(subcases$start)

## use location columns to find lat long location
library(ggmap)
library(plyr)
gisdf <-geocode(paste(subcases$address,subcases$city,subcases$state,"Malaysia",sep=","))
subcases<-cbind(gisdf,subcases)
subcases<-subcases[order(subcases$cases),]
means<-tapply(as.numeric(subcases$cases),subcases$state,mean)
counts<-tapply(as.numeric(subcases$cases),subcases$state,count)
## plot cases using lat long, weight with number of cases
qplot(rownames(means),means)
plot(subcases$week,subcases$cases)
plot(subcases$year,subcases$cases)
plot(subcases$duration,subcases$cases)
plot(subcases$lat,subcases$cases)
plot(subcases$lon,subcases$lat)
## explore relationship between number of cases, duration, location

## overlap with external data - weather, precipatition, population, age ranges, density

