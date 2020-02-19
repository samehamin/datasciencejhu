library('dplyr')

# csvfile <- download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv', 
#                         'data/uscommunities.csv')

df <- read.csv('data/uscommunities.csv')

sum(df$VAL==24 & !is.na(df$VAL))