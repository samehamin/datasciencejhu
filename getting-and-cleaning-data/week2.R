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






