## Reading from mysql

#  UCSC Genome Browser
library(RMySQL)

# mysql connect to ucsc mysql db 
ucscDb <- dbConnect(MySQL(), user = "genome",
                    host = "genome-mysql.cse.ucsc.edu")

result <- dbGetQuery(ucscDb, "show databases;")
dbDisconnect(ucscDb)

# hg19 db and list tables
hg19 <- dbConnect(MySQL(), user = "genome", db = "hg19",
                  host = "genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]

# Get dimensions of table
dbListFields(hg19, "affyU133Plus2")
dbGetQuery(hg19, "select count(*) from affyU133Plus2")

# Read from table
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

# Select dataset from table
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)

affyMisSmall <- fetch(query, n=10); dbClearResult(query)
dim(affyMisSmall)

dbDisconnect(hg19)

# =========================================================================

## Read from HDF5
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")

# BiocManager::install("rhdf5")


library("rhdf5")

created = h5createFile("example.h5")
created = h5createGroup("example.h5", "foo")
created = h5createGroup("example.h5", "baa")
created = h5createGroup("example.h5", "foo/foobaa")

h5ls("example.h5")


# Write to groups
A = matrix(1:10, nr=5, nc=2)
h5write(A, "example.h5","foo/A")

B = array(seq(0.1, 2.0, by=0.1), dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5","foo/B")

h5ls("example.h5")


# Write a dataset
df = data.frame(1L:5L, seq(0,1,length.out = 5),
                c("ab", "cde", "fghi", "a", "s"), stringsAsFactors = FALSE)
h5write(df, "example.h5","df")

h5ls("example.h5")



# Reading Data
readA = h5read("example.h5","foo/A")
readA


# Wrting and reading chunks
h5write(c(12, 13, 14), "example.h5","foo/A", index=list(1:3, 1))
h5read("example.h5","foo/A")

# =========================================================================



## Read from web

# Getting data off webpages
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")

htmlCode = readLines(con)
close(con)
htmlCode


# parsing with xml
library(XML)
library(httr)

url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
r = GET(url)

html <- htmlTreeParse(r, useInternalNodes = T)

xpathSApply(html, "//title", xmlValue)
xpathSApply(html, "//div[@id='gs_md_ldg']", xmlValue)


# Get from the httr package
library(httr)
html2 = GET(url)
content2 = content(html2, as="text")
parsedHtml = htmlParse(content2, asText = TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)

# Accessing websites with passwords
pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user", "passwd"))
pg2

names(pg2)

# Using handles
google = handle("http://google.com")
pg1 = GET(handle = google, path = "/")
pg1 = GET(handle = google, path = "search")

# =========================================================================


## Reading from APIs
myapp = oauth_app("twitter", 
                  key = "8omqHSHsQ4SpV8Ms3p0ARWD8r",
                  secret = "BLYRvNNsz2NUSi2noyPbagcHWP3ycaoJ15KMTzgEbgIzHNky9E")

sig = sign_oauth1.0(myapp, 
                    token = "727768696073105408-FdkjBIqw0Ooib7ZQ8SfmWQ1Eo9s8K4O",
                    token_secret = "DwshDowuwFwoVJ9kAtiN17ljtT7edbZjWR46P4pOipURl")

homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)

# converting the json
json1 = content(homeTL)
json2 = jsonlite::fromJSON(jsonlite::toJSON(json1))

json2[1, 1:4]

# =========================================================================


## Week 2 Quiz

# Question 1 - Github
library(httr)
library(httpuv)
library(jsonlite)


githuburl = "http://api.github.com/users/jtleek/repos"
appname = "datasciencejhu"
appkey = "ba2337f28410327edbf7"
appsecret = "367841afcb06b5ddb37fc2a9144cb0b7f5b6023f"
# apptoken <- "c5f001cabfc6a6736248c89ff99083df21c5039d"

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what you 
myapp <- oauth_app(appname = appname,
                   key = appkey,
                   secret = appsecret)

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET(githuburl, gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 



# Question 2
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "data/americansurvey.csv")

acs <- read.csv("data/americansurvey.csv", header=T, sep=",")
library("sqldf")
sqldf("select pwgtp1 from acs where AGEP < 50")


# Question 3
sqldf("select distinct AGEP from acs")


# Question 4
library(XML)
library(httr)

hurl <- "http://biostat.jhsph.edu/~jleek/contact.html"
con <- url(hurl)
htmlcode <- readLines(con)
close(con)
sapply(htmlcode[c(10, 20, 30, 100)], nchar)


# Question 5
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for", "data/kss8110.for")

data <- read.csv("data/kss8110.for", header = TRUE)

