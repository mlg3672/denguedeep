## set working directory
setwd("~/Documents/Python-Projects/dengue")

## read dengue csv into dataframe
cases<-read.csv("dengue.csv", colClasses="character")

# clean data ----------------
## set column names
colnames(cases)<- c("year","week","state","city","address","cases","duration")
cases<-cases[,1:7]
dim(cases)


##subset cases
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
subcases$start<-as.Date(paste(subcases$year,"01","01",sep="-")) + as.numeric(subcases$week)*7
subcases$end<- subcases$start + as.numeric(subcases$duration)
subcases$month<-month(subcases$start)
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
gisdf <-geocode(paste(subcases$address,subcases$city,subcases$state,"Malaysia",sep=","))
subcases<-cbind(gisdf,subcases)
subcases<-subcases[order(subcases$cases),]
means<-tapply(as.numeric(subcases$cases),subcases$cleanstate,mean)
medians<-tapply(as.numeric(subcases$cases),subcases$cleanstate,median)
sums<-tapply(as.numeric(subcases$cases),subcases$cleanstate,sum)

# split data by state
select1<-subcases$cleanstate=="Selangor"
select2<-subcases$cleanstate=="Kelantan"
subSelangor<-subcases[select1,]
subKelantan<-subcases[select2,]

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

# get precipatition for state

# bind population data for state, city 

