## set working directory
setwd("Documents/Python-Projects/dengue")

## read dengue csv into dataframe
cases<-read.csv("dengue.csv", colClasses="character")

## set column names
header<- c("year","week","state","city","address","cases","duration")

## new column 'locale' concatenate location address,city,state,country
cases$locale <-
## use location columns to find lat long location
library(ggmap)
cases$long,cases$lat <-geocode(cases.locale)
## make a new data frame with start and stop dates
library(lubridate)
cases$start<-
cases$end<-
## plot cases using lat long, weight with number of cases

## explore relationship between number of cases, duration, location

## overlap with external data - weather, precipatition, population, age ranges, density

