# Answers
# https://github.com/UtkarshPathrabe/Getting-And-Cleaning-Data-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/blob/master/Quiz%2001/Quiz%2001.md


library('dplyr')
library(readxl)
library(xml2)


# The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: 
# csvfile <- download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv', 
#                         'data/uscommunities.csv')

df <- read.csv('data/uscommunities.csv')

sum(df$VAL==24 & !is.na(df$VAL))


# 3. Download the Excel spreadsheet on Natural Gas Aquisition Program here: 
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx",
#                           "getdata_data_DATA.gov_NGAP.xlsx")


data_gas <- read_xlsx("data/getdata_data_DATA.gov_NGAP.xlsx")

dat <- data_gas[18:23, 7:15]
colnames(dat) <- data_gas[17, 7:15]

sum(as.numeric(dat$Zip) * as.numeric(dat$Ext), na.rm = T)

#======================================================================

# 4. Read the XML data on Baltimore restaurants from here:
# How many restaurants have zipcode 21231? 
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml", "data/restaurants.xml")

data_rest <- read_xml("data/restaurants.xml")
allzipcodes <- xml_find_all(data_rest, ".//zipcode")
zipcodedf <- as.numeric(xml_text(allzipcodes))
length(zipcodedf[zipcodedf == 21231])

#======================================================================

# 5. The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: 

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "data/pid.csv")

DT <- read.table("data/pid.csv", sep = ",", header = TRUE)

testtime <- function(func1, func2 = NULL){
  start_time <- Sys.time()
  func1
  func2
  end_time <- Sys.time()
  end_time - start_time
}

testtime(
  sapply(split(DT$pwgtp15,DT$SEX),mean)
)


testtime(
  mean(DT[DT$SEX==1,]$pwgtp15),
  mean(DT[DT$SEX==2,]$pwgtp15)
)

system.time(
  tapply(DT$pwgtp15,DT$SEX,mean)
)

testtime(
  rowMeans(DT)[DT$SEX==1],
  rowMeans(DT)[DT$SEX==2]
)

testtime(
  mean(DT$pwgtp15,by=DT$SEX)
)

testtime(
  DT[,mean(pwgtp15),by=SEX]
)


