library('dplyr')


# Q1

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "data/us_communities.csv")
data <- read.csv("data/us_communities.csv")
head(data)

# Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of agriculture products. Assign that logical vector to the variable agricultureLogical
agricultureLogical = data$ACR==3 & data$AGS == 6


# Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE
head(which(agricultureLogical), 3)


# Q2

# Using the jpeg package read in the following picture of your instructor into R
#install.packages('jpeg'), Use the parameter native=TRUE
library('jpeg')
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", "data/image.jpg")
img <- jpeg::readJPEG('data/image.jpg'
                          , native=TRUE)

# What are the 30th and 80th quantiles of the resulting data
quantile(img, probs = c(0.3, 0.8) )



