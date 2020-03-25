# Generating data
set.seed(13435)
X <- data.frame("var1"=sample(1:5), "var2"=sample(6:10), "var3"=sample(11:15))
X <- X[sample(1:5),]
X$var2[c(1,3)] = NA
X
X[, 1]
X[,"var1"]
X[1:2,"var2"]


# Logical ands and ors
X[(X$var1 <= 3 & X$var3 > 11), ]
X[(X$var1 <= 3 | X$var3 > 15), ]


# missing values
X[which(X$var2 > 8),]


# Sorting
sort(X$var1)
sort(X$var1, decreasing = TRUE)
sort(X$var2, na.last = TRUE)


# Ordering
X[order(X$var1, X$var3),]

library(plyr)
arrange(X, var1)
arrange(X, desc(var1))


# Adding rows and columns
Y <- cbind(X, rnorm(5))
Y


# Summarizing data
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, "./data/restaurant.csv", method = "curl")

restData <- read.csv("./data/restaurant.csv")
head(restData, 3)
tail(restData, 3)
summary(restData)
str(restData)
quantile(restData$councilDistrict, na.rm = TRUE)
quantile(restData$councilDistrict, probs = c(0.5, 0.75, 0.9))
table(restData$zipCode, useNA = "ifany")
table(restData$councilDistrict, restData$zipCode)

# Check for missing values
sum(is.na(restData$councilDistrict))
any(is.na(restData$councilDistrict))
all(restData$zipCode > 0)

# row and column sums
colSums(is.na(restData))
all(colSums(is.na(restData)) == 0)

# find values with specific chars
table(restData$zipCode %in% c(21212))
table(restData$zipCode %in% c(21212, 21213))
restData[restData$zipCode %in% c(21212, 21213),]

# Cross tabs
data("UCBAdmissions")
df = as.data.frame(UCBAdmissions)
summary(df)
xt <- xtabs(Freq ~ Gender + Admit, data = df)
xt


# Flat tables
warpbreaks$replicate <- rep(1:9, len = 54)
xt = xtabs(breaks ~ ., data = warpbreaks)
xt

ftable(xt)

# Size of data set
fakeData = rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData), units="Mb")


# Creating new variables

## creating sequences
s1 <- seq(1,10,by=2) ; s1
s2 <- seq(1,10,length=3) ; s2
x <- c(1,3,8,25,100) 
s3 <- seq(along = x) ; s3

## Subsetting
restData$nearMe = restData$neighborhood %in% c("Roland Park", "Homeland")
table(restData$nearMe)

## Creating binary vars
restData$zipWrong = ifelse(restData$zipCode < 0, TRUE, FALSE)
table(restData$zipWrong)

## Creating categorical vars
restData$zipGroups = cut(restData$zipCode, breaks = quantile(restData$zipCode))
table(restData$zipGroups)
table(restData$zipGroups, restData$zipCode)

## Easier cutting
#install.packages("Hmisc")
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode,g=4)
table(restData$zipGroups)

## Creating factor vars
restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]

## Levels of factor vars
yesno <- sample(c("yes", "no"), size = 10, replace = TRUE)
yesnofac = factor(yesno, levels = c("yes","no"))
relevel(yesnofac,ref = "yes")
as.numeric(yesnofac)

## Cutting produces factor vars
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode, g=4)
table(restData$zipGroups)

## Using the mutate function
library(Hmisc) ; library(plyr)
restData2 = mutate(restData, zipGroups=cut2(zipCode, g=4))
table(restData2$zipGroups)


# Melting data frames

## reshaping
library(reshape2)
head(mtcars)

mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars = c("mpg", "hp"))
head(carMelt,3)

# Casting data frames
cylData <- dcast(carMelt, cyl~variable)
cylData

cylData <- dcast(carMelt, cyl~variable, mean)
cylData

## Averaging values
data("InsectSprays")
head(InsectSprays)

tapply(InsectSprays$count, InsectSprays$spray, sum)

## Another way - split
spIns <- split(InsectSprays$count, InsectSprays$spray)
spIns

## Another way - apply
sprCount <- lapply(spIns, sum)
sprCount

## Another way - combine
unlist(sprCount)
# OR
sapply(spIns, sum)

## Another way - plyr package
ddply(InsectSprays, .(spray), summarize, sum=sum(count))

## Creating new vars
spraySums <- ddply(InsectSprays, .(spray), summarize, sum=ave(count, FUN=sum))
dim(spraySums)
head(spraySums)


# Managing Data Frames with dplyr - Basic Tools
fileURL <- "https://github.com/DataScienceSpecialization/courses/blob/master/03_GettingData/dplyr/chicago.rds?raw=true"
download.file(fileURL, destfile = "./data/chicago.rds", method = "curl", extra='-L')

library(dplyr)
options(width = 105)

chicago <- readRDS("data/chicago.rds")
dim(chicago)
str(chicago)
names(chicago)

i <- match("city", names(chicago))
j <- match("dptp", names(chicago))
head(chicago[, -(i:j)])

chic.f <- filter(chicago, pm25tmean2 > 30)
head(chic.f, 10)

#rename 
chicago <- rename(chicago, pm25 = pm25tmean2, dewpoint = dptp)
head(chicago)

# create new vars
chicago <- mutate(chicago, tempcat = factor(1 * (tmpd > 80), labels = c("cold", "hot")))
tail(chicago)
hotcold <- group_by(chicago, tempcat)
head(hotcold)
summarize(hotcold, pm25 = mean(pm25), o3 = max(o3tmean2), no2 = median(no2tmean2))


# Merging Data
# Peer review data
# fileUrl1 = "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
# fileUrl2 = "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
# download.file(fileUrl1,destfile="./data/reviews.csv",method="curl")
# download.file(fileUrl2,destfile="./data/solutions.csv",method="curl")
reviews = read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")
head(reviews,2)

names(reviews)
names(solutions)

# Merge
mergedData = merge(reviews, solutions, by.x = "solution_id", by.y = "id", all=TRUE)
head(mergedData)

# Intersect
intersect(names(solutions), names(reviews))

# dplyr join
library(dplyr)
options(width = 105)
df1 = data.frame(id=sample(1:10), x=rnorm(10))
df2 = data.frame(id=sample(1:10), y=rnorm(10))
arrange(join(df1, df2), id)

df3 = data.frame(id=sample(1:10), z=rnorm(10))
dfList = list(df1, df2, df3)
arrange(join_all(dfList), id)
