##
## Name: Prepare Data
## Purpose: This script will download and create a sample size of the data used by the N Gram Generator 
##          to create a corpus and tokenize
##
#-----------------------------------------------------------------------------------------------
# Make sure you download and save the data  in your working directory
#-----------------------------------------------------------------------------------------------
if (!file.exists(paste(getwd(),"/Coursera-SwiftKey.zip",sep=""))) {
  dlurl <- 'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip'  
  download.file(dlurl,destfile='Coursera-SwiftKey.zip',mode='wb')  
  unzip('Coursera-SwiftKey.zip')
}
#-----------------------------------------------------------------------------------------------
# Based on the size we will need to keep in mind how big the sample size can be as response times need to be in subseconds.
#Now lets get sum summary stats on the three files.
#-----------------------------------------------------------------------------------------------
blogs_en <- readLines("final/en_US/en_US.blogs.txt", n = -1L, ok = TRUE, warn = FALSE, encoding = "UTF-8", skipNul = FALSE)
news_en  <- readLines("final/en_US/en_US.news.txt", n = -1L, ok = TRUE, warn = FALSE, encoding = "UTF-8", skipNul = FALSE)
twitter_en <- readLines("final/en_US/en_US.twitter.txt", n = -1L, ok = TRUE, warn = FALSE, encoding = "UTF-8", skipNul = FALSE)

#-----------------------------------------------------------------------------------------------
#Get File Stats to support genetrating appropriate sample sizes.
#-----------------------------------------------------------------------------------------------

#Create sample outputs for use in corpus - sample size based on using 10% of lines in each file. Except Twitter 5%
#This will help speed up processing.
Twitter_Rows <- length(twitter_en)
News_Rows <- length(news_en)
Blogs_Rows <- length(blogs_en)
Samplesize_Twitter <- Twitter_Rows*0.01
Samplesize_News <- News_Rows*0.09
Samplesize_Blogs <- Blogs_Rows*0.09
SampleTwitter <- twitter_en[sample(1:length(twitter_en),Samplesize_Twitter)]
SampleNews <- news_en[sample(1:length(news_en),Samplesize_News)]
SampleBlogs <- blogs_en[sample(1:length(blogs_en),Samplesize_Blogs)]
CombinedSample <- c(SampleTwitter,SampleNews,SampleBlogs)

#Save off the Sample for use in building the corpus
if (!file.exists("C:/coursera/Capstone/data"))
{
  dir.create(file.path("C:/coursera/Capstone","data"))
} 
if (!file.exists("C:/coursera/Capstone/data/CombinedSample.txt"))
{
  writeLines(CombinedSample, "C:/coursera/Capstone/data/CombinedSample.txt")
} else {
  file.remove("C:/coursera/Capstone/data/CombinedSample.txt")
  writeLines(CombinedSample, "C:/coursera/Capstone/data/CombinedSample.txt")
}
#-----------------------------------------------------------------------------------------------