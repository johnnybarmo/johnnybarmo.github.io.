#Installing packages
install.packages("ggmap")
install.packages("lubridate")
install.packages("tidyverse")
install.packages("skimr")
install.packages("janitor")
install.packages("geosphere")
install.packages("clock")
install.packages("hms")
install.packages("dplyr")

# Loading libraries
library(ggmap)
library(lubridate)
library(tidyverse)
library(skimr)
library(janitor)
library(geosphere)
library(clock)
library(hms)
library(dplyr)

#Uploading data collected between January 2022 and December 2022
jan_2022 <- read.csv("202201-divvy-tripdata.csv")
feb_2022 <- read.csv("202202-divvy-tripdata.csv")
mar_2022 <- read.csv("202203-divvy-tripdata.csv")
apr_2022 <- read.csv("202204-divvy-tripdata.csv")
may_2022 <- read.csv("202205-divvy-tripdata.csv")
jun_2022 <- read.csv("202206-divvy-tripdata.csv")
jul_2022 <- read.csv("202207-divvy-tripdata.csv")
aug_2022 <- read.csv("202208-divvy-tripdata.csv")
sep_2022 <- read.csv("202209-divvy-publictripdata.csv")
oct_2022 <- read.csv("202210-divvy-tripdata.csv")
nov_2022 <- read.csv("202211-divvy-tripdata.csv")
dec_2022 <- read.csv("202212-divvy-tripdata.csv")

#Inspecting the data
str(jan_2022)
colnames(jan_2022)
str(feb_2022)
colnames(feb_2022)
str(mar_2022)
colnames(mar_2022)
str(apr_2022)
colnames(apr_2022)
str(may_2022)
colnames(may_2022)
str(jun_2022)
colnames(jun_2022)
str(jul_2022)
colnames(jul_2022)
str(aug_2022)
colnames(aug_2022)
str(sep_2022)
colnames(sep_2022)
str(oct_2022)
colnames(oct_2022)
str(nov_2022)
colnames(nov_2022)
str(dec_2022)
colnames(dec_2022)

#Merging the data sets into 1 frame
trips_2022 <- bind_rows(jan_2022,feb_2022,mar_2022,apr_2022,may_2022,jun_2022,jul_2022,aug_2022,sep_2022,oct_2022,nov_2022,dec_2022)

#Adding a ride_length column and calculating it
trips_2022 <- trips_2022 %>% mutate(across(c(started_at, ended_at), ymd_hms), ride_length = difftime(ended_at, started_at,units='mins'))

#Converting it to a numeric data type
trips_2022 <- mutate(trips_2022, ride_length = as.numeric(ride_length))

#Removing the NA fields, duplicate rows and inspecting the new data frame structure
trips_2022_final <- drop_na(trips_2022)
trips_2022_final <- distinct(trips_2022_final)
str(trips_2022_final)

#Creating a table showcasing bike type data
table(trips_2022_final$rideable_type)

#Creating a table showcasing rider type data
table(trips_2022_final$member_casual)

#Summarizing the ride length
summary(trips_2022_final$ride_length)

#After inspection of the results, removing negative ride lengths rows
trips_2022_final <- trips_2022_final[!(trips_2022_final$ride_length<0),]

#Creating an updated ride length summary
summary(trips_2022_final$ride_length)

#Calculating the mean and median ride length by customer type
aggregate(trips_2022_final$ride_length ~ trips_2022_final$member_casual, FUN=mean)
aggregate(trips_2022_final$ride_length ~ trips_2022_final$member_casual, FUN=median)

#Adding multiple columns to specify the date, month, day and start_hour of each ride
trips_2022_final$date <- as.Date(trips_2022_final$started_at)
trips_2022_final$month <- format(as.Date(trips_2022_final$date), "%m")
trips_2022_final$day <- format(as.Date(trips_2022_final$date), "%d")
trips_2022_final$day_of_week <- format(as.Date(trips_2022_final$date), "%A")
trips_2022_final$start_hour <- format(as.POSIXct(trips_2022_final$started_at), "%H")

#Calculating the ride_distance in KM
trips_2022_final$ride_distance <- distGeo(matrix(c(trips_2022_final$start_lng, trips_2022_final$start_lat), ncol=2), matrix(c(trips_2022_final$end_lng, trips_2022_final$end_lat), ncol=2))
trips_2022_final$ride_distance <- trips_2022_final$ride_distance/1000

#Calculating avg ride_distance by customer type
customer_type_means <- trips_2022_final %>%
  group_by(member_casual) %>%
  summarise(mean_time = mean(ride_length), mean_distance = mean(ride_distance))

#Creating a column to showcase different seasons
trips_2022_final<- trips_2022_final %>%
  mutate(season=
           case_when(month =="03" ~ "Spring",
                     month =="04" ~ "Spring",
                     month =="05" ~ "Spring",
                     month =="06" ~ "Summer",
                     month =="07" ~ "Summer",
                     month =="08" ~ "Summer",
                     month =="09" ~ "Fall",
                     month =="10" ~ "Fall",
                     month =="11" ~ "Fall",
                     month =="12" ~ "Winter",
                     month =="01" ~ "Winter",
                     month =="02" ~ "Winter",))
#Creating a column for time_of_the_day
trips_2022_final<- trips_2022_final %>%
  mutate(time_of_day =
           case_when(start_hour =="00" ~ "Night",
                     start_hour =="01" ~ "Night",
                     start_hour =="02" ~ "Night",
                     start_hour =="03" ~ "Night",
                     start_hour =="04" ~ "Night",
                     start_hour =="05" ~ "Night",
                     start_hour =="06" ~ "Morning",
                     start_hour =="07" ~ "Morning",
                     start_hour =="08" ~ "Morning",
                     start_hour =="09" ~ "Morning",
                     start_hour =="10" ~ "Morning",
                     start_hour =="11" ~ "Morning",
                     start_hour =="12" ~ "Afternoon",
                     start_hour =="13" ~ "Afternoon",
                     start_hour =="14" ~ "Afternoon",
                     start_hour =="15" ~ "Afternoon",
                     start_hour =="16" ~ "Afternoon",
                     start_hour =="17" ~ "Afternoon",
                     start_hour =="18" ~ "Evening",
                     start_hour =="19" ~ "Evening",
                     start_hour =="20" ~ "Evening",
                     start_hour =="21" ~ "Evening",
                     start_hour =="22" ~ "Evening",
                     start_hour =="23" ~ "Evening"))
#Creating a month_name column
trips_2022_final <- trips_2022_final %>%
  mutate(month_name = 
           case_when(month == "01" ~ "January",
                     month == "02" ~ "February",
                     month == "03" ~ "March",
                     month == "04" ~ "April",
                     month == "05" ~ "May",
                     month == "06" ~ "June",
                     month == "07" ~ "July",
                     month == "08" ~ "August",
                     month == "09" ~ "September",
                     month == "10" ~ "October",
                     month == "11" ~ "November",
                     month == "12" ~ "December"))

#Rounding the ride_length
trips_2022_final$ride_length <- round(trips_2022_final$ride_length, digits= 0)
#Downloading the final data as a .csv file
install.packages("data.table")
library(data.table)
fwrite(trips_2022_final, "Cyclistic_data_2022_tableau.csv")