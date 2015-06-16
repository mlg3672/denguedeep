## set working directory
setwd("Documents/Python-Projects/dengue")

## read dengue csv into dataframe
cases<-read.csv("dengue.csv", colClasses="character")

## set column names
colnames(cases)<- c("year","week","state","city","address","cases","duration")

## use location columns to find lat long location
library(ggmap)
cases$longlat <-as.numeric(geocode(paste(cases$addresss,cases$city,cases$state,"Malaysia",sep=",")))

## make a new data columns with start and stop dates
library(lubridate)
cases$start<-as.Date(paste(cases$year,"01","01",sep="-") + cases$weeks*7
cases$end<- cases$start + cases$duration
cases$month<-month(cases$start)

## plot cases using lat long, weight with number of cases

## explore relationship between number of cases, duration, location

## overlap with external data - weather, precipatition, population, age ranges, density

