##
## Name: Generate N Grams
## Purpose: This script will genrate the corpus and the N Gram R Data files for the Shiny App
##
#-----------------------------------------------------------------------------------------------
suppressWarnings(library(tm))
suppressWarnings(library(R.utils))
suppressWarnings(library(SnowballC))
suppressWarnings(library(RWeka))
suppressWarnings(library(data.table))
#-----------------------------------------------------------------------------------------------
#Read the Dataset - Reference PrepareData.R on details of the sample file that was generated.Create 
# the corpus which will be used by the tokenizer.
#-----------------------------------------------------------------------------------------------
cname <-  "C:/coursera/Capstone/Shiny/data/"
dir(cname)   
docs <- Corpus(DirSource(cname))

for(j in seq(docs))
{
  docs[[j]] <- gsub(":", " ", docs[[j]])
  docs[[j]] <- gsub("\n", " ", docs[[j]])
  docs[[j]] <- gsub("-", " ", docs[[j]])
}

#Perform Preprocessing and harmonization.
docs <- tm_map(docs, removePunctuation) 
#docs <- tm_map(docs, removeWords, profanityWords)
docs <- tm_map(docs, removeNumbers)      # *Removing numbers:*    
docs <- tm_map(docs, tolower)   # *Converting to lowercase:*    
docs <- tm_map(docs, removeWords, stopwords("english"))   # *Removing "stopwords" 
docs <- tm_map(docs, stemDocument)   # *Removing common word endings* (e.g., "ing", "es")   
docs <- tm_map(docs, stripWhitespace)   # *Stripping whitespace   
docs <- tm_map(docs, PlainTextDocument)   

#-----------------------------------------------------------------------------------------------
#Create the tokenizer parameters for Bigrams and Trigrams 
#Using the TermDocumentMatrix by default toeknizes single words. This is part of the NLP package.
#-----------------------------------------------------------------------------------------------
tdm <- TermDocumentMatrix(docs) 

#Remove non relevant data - Start by removing sparse terms and then tokenize:   
tdm <- TermDocumentMatrix(docs) 
tdms <- removeSparseTerms(tdm, 0.1) # This makes a matrix that assumes only terms that have only 10% empty space- this will help eliminate a lot of insignifant rows. 
Bigram_Tokenizer <- function(x) RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 2, max = 2))
Trigram_Tokenizer <- function(x) RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 3, max = 3))
Quadgram_Tokenizer <- function(x) RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 4, max = 4))

#After tokenization load the parsed data into a data rframe to understand frequency of occurance. 
unigram <- TermDocumentMatrix(docs)
bigram <- TermDocumentMatrix(docs, control = list(tokenize = Bigram_Tokenizer))
trigram <- TermDocumentMatrix(docs, control = list(tokenize = Trigram_Tokenizer))
quadgram <- TermDocumentMatrix(docs, control = list(tokenize = Quadgram_Tokenizer))

#Now sort based on frequecny in descending order  
unigram_freq <- sort(rowSums(as.matrix(unigram)), decreasing=TRUE)
bigram_freq <- sort(rowSums(as.matrix(bigram)), decreasing=TRUE)
trigram_freq <- sort(rowSums(as.matrix(trigram)), decreasing=TRUE)
quadgram_freq <- sort(rowSums(as.matrix(quadgram)), decreasing=TRUE)

#Now load the data into a data table to support saving as .RDATA file for the app to use.  
unigram_DT <- data.table(terms=names(unigram_freq), freq=unigram_freq)
bigram_DT <- data.table(terms=names(bigram_freq), freq=bigram_freq)
trigram_DT <- data.table(terms=names(trigram_freq), freq=trigram_freq)
quadgram_DT <- data.table(terms=names(quadgram_freq), freq=quadgram_freq)

#Now write the data table out to support the creation of an RData Object to support App Performance.
write.table(unigram_DT, "unigram_data", col.names = TRUE)
write.table(bigram_DT, "bigram_data", col.names = TRUE)
write.table(trigram_DT, "trigram_data", col.names = TRUE)
write.table(quadgram_DT, "quadgram_data", col.names = TRUE)
  
#-----------------------------------------------------------------------------------------------

#Create the Save Data Tables 
unigram_data_save <- read.table("C:/coursera/Capstone/AppData/unigram_data", header = TRUE, stringsAsFactors = FALSE)
bigram_data_save <- read.table("C:/coursera/Capstone/AppData/bigram_data", header = TRUE, stringsAsFactors = FALSE)
trigram_data_save <- read.table("C:/coursera/Capstone/AppData/trigram_data", header = TRUE, stringsAsFactors = FALSE)
quadgram_data_save <- read.table("C:/coursera/Capstone/AppData/quadgram_data", header = TRUE, stringsAsFactors = FALSE)

# Subset the data frames based on the frequency Note: Unigrams have higher frequency clusters so we need to use a higher number
unigram_data_save <- unigram_data_save[unigram_data_save$freq > 100,]
bigram_data_save <- bigram_data_save[bigram_data_save$freq > 2,]
trigram_data_save <- trigram_data_save[trigram_data_save$freq > 2,]
quadgram_data_save <- quadgram_data_save[quadgram_data_save$freq > 2,]

# Define file names with relative folder path
setwd('C:/coursera/Capstone/Shiny/AppData')

save(unigram_data_save, file="unigram_data_save.RData");
save(bigram_data_save, file="bigram_data_save.RData");
save(trigram_data_save, file="trigram_data_save.RData");
save(quadgram_data_save, file="quadgram_data_save.RData");

#Load the Data Sets in Memory for use by the App
load("unigram_data_save.RData")
load("bigram_data_save.RData")
load("trigram_data_save.RData")
load("quadgram_data_save.RData")
#-----------------------------------------------------------------------------------------------