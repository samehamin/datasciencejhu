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





