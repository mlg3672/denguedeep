## set working directory
setwd("~/Documents/Python-Projects/dengue")

## read dengue csv into dataframe
cases<-read.csv("dengue.csv", colClasses="character")

# clean data ----------------
## set column names
colnames(cases)<- c("year","week","state","city","address","cases","duration")
cases<-cases[,1:7]
dim(cases)

## select all cases by location
unique(cases$state)
Penangcases<-cases[grepl("Pinang",cases$state),]
Selangorcases<-cases[grepl("elangor",cases$state),]
dim(Penangcases)
dim(Selangorcases)

##subset cases, pick random rows
subcases<-cases[sample(nrow(cases), 300), ]

# clean state and city variables
library(stringr)
subcases$cleanstate<-str_trim(subcases$state)
subcases$cleancity<-str_trim(subcases$city)
# check cleaning
unique(subcases$state)
unique(subcases$cleanstate)
unique(subcases$city)
unique(subcases$cleancity)

# data transformations -----
## make a new data columns with start and stop dates
library(lubridate)
addStart <- function(subcases) {
  subcases$start<-as.Date(paste(subcases$year,"01","01",sep="-")) + as.numeric(subcases$week)*7
  subcases$end<- subcases$start + as.numeric(subcases$duration)
  subcases$month<-month(subcases$start)
  subcases
}

Selangorcases<-addStart(Selangorcases)

# check for na values
isna<-is.na(subcases$cases)
# replace na with median
subcases$statecases<-medians[subcases$state]
subcases$adjcases<-subcases$cases
subcases$adjcases<-subcases[isna,statecases]
#logcases
subcases$logcases<-log(as.numeric(subcases$cases))

## use location columns to find lat long location
library(ggmap)
library(plyr)
geoCode <- function(df) {
  gisdf <-geocode(paste(subcases$address,subcases$city,subcases$state,"Malaysia",sep=","))
  subcases<-cbind(gisdf,subcases)
  subcases
}


#cut into 4 pieces 2400 per day for gis call
selOne<-Selangorcases[1:2400,]
selTwo<-Selangorcases[2401:4500,]
selThree<-Selangorcases[4801:7105,]

gisdf <-geocode(paste(selTwo$address,selTwo$city,selTwo$state,"Malaysia",sep=","))
selTwogis<-cbind(gisdf,selTwo)
 

rbind(selOnegis, selTwogis,selThreegis)

# get statistics of cases
cityMeans <- function(df,cleanstate) {
  means<-tapply(as.numeric(subcases$cases),subcases$cleanstate,mean)
  medians<-tapply(as.numeric(subcases$cases),subcases$cleanstate,median)
  sums<-tapply(as.numeric(subcases$cases),subcases$cleanstate,sum)
  print("means",means)
  print("medians",medians)
  print("sums", sums)
}

cityMeans(Selangorcases,city)

# back generate data - row for each case
subcases.expanded<- subcases[rep(row.names(subcases), subcases$cases), c(1:3, 7,12:14)]
colnames(subcases.expanded)<-c("lon","lat","year","address","month","state","city")
# split data by state
select1<-subcases$cleanstate=="Selangor"
select2<-subcases$cleanstate=="Kelantan"
subSelangor<-subcases[select1,]
subKelantan<-subcases[select2,]

# write data to csv
write.csv(x=subSelangor,file="subSelangor1.csv")
#subSelangor1<-read.csv("subSelangor1.csv")
write.csv(x=subcases.expanded,file="onecaseperrow.csv")
# explore data ---------------------
## bar plot mean and total cases by state 
sortedmeans<-means[order(as.numeric(means),decreasing = T)]
sortedsums<-sums[order(as.numeric(sums),decreasing = T)]
barplot(names.arg=rownames(sortedsums),
        height=sortedsums,
        col="light blue", 
        main="Total Recorded Dengue Cases by State 2011- 2014")
## plot cases by week
# sum cases over all weeks
casesbyweek<-tapply(as.numeric(subcases$cases),subcases$week, sum)
sortedcasesbyweek<-casesbyweek[order(as.numeric(names(casesbyweek)),decreasing = T)]
plot(rownames(sortedcasesbyweek),sortedcasesbyweek,type="l")
# sum cases over all years
casesbyyear<-tapply(as.numeric(subcases$cases),subcases$year, sum)
sortedcasesbyyear<-casesbyyear[order(as.numeric(names(casesbyyear)),decreasing = F)]
barplot(names.arg=rownames(sortedcasesbyyear),height=sortedcasesbyyear,col="light green")
# plot by lat,lon
plot(subcases$lat,subcases$cases)
plot(subcases$lon,subcases$lat)


## overlap with external data ------------

# getweather for state 
library(weatherData)
# get humidity, temp, precipitation
we <- getWeatherForDate("WMKP", min(subcases$start), opt_detailed=T, opt_custom_columns=T, custom_columns=c(1,2,4,10))
getDetailedWeather(station_id = "WMKP",date="2015-07-01")
getCurrentTemperature(station_id = "WMKP")
checkSummarizedDataAvailability(station_id = "WMKP",start_date=min(subcases$start),end_date = max(subcases$start))
# subset weather results to max, median temp, total precipitation for each day's weather
# get dates 
alldates <- seq(from=as.POSIXct(min(subcases$start)), to=as.POSIXct(max(subcases$start)), by='day')
casesdates<-subcases$start
futuredates<-seq(from=as.POSIXct(max(subcases$start)), to=as.POSIXct(Sys.time()), by='day')
# get precipatition for state

# bind population data for state, city 

