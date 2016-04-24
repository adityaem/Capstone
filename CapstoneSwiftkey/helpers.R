##
## Name: helpers.R 
## Purpose: helper functions for Word Predictor Application
## Functions: Load Data & Libraries, Load Next Word Prediction Function using Katz, Clean String Function.
## Date: April 2016
## Author: AKT
##
#-----------------------------------------------------------------------------------------------------------
# Load Libraries and import helper functions
#-----------------------------------------------------------------------------------------------------------
suppressWarnings(library(tm))
suppressWarnings(library(stringr))
suppressWarnings(library(shiny))
suppressWarnings(library(wordcloud))
suppressWarnings(library(dplyr))

#-----------------------------------------------------------------------------------------------------------
# Now load the One-Gram, Two-Gram, Three-Gram and Four-Gram Data frame files which were created by the 
# "GenerateNGramsII.R. Note this data has already been cleansed with N-Grams frequency in decending order
# The data was converted to lower case, punctuations removed, numbers removed,stop words removed, carraige returns, 
# white spaces removed & non print characters removed.
#-----------------------------------------------------------------------------------------------------------
load("./AppData/unigram_data_save.RData");
load("./AppData/bigram_data_save.RData");
load("./AppData/trigram_data_save.RData");
load("./AppData/quadgram_data_save.RData");

# Initialize variables.
mesg <- as.character(NULL);
Wordcloud_Flag<- FALSE;

#-----------------------------------------------------------------------------------------------------------
# This function "Clean up" the user input string before it is used to predict the next term
#-----------------------------------------------------------------------------------------------------------
CleanInputString <- function(inStr)
{
  
  # First remove the non-alphabatical characters
  inStr <- iconv(inStr, "latin1", "ASCII", sub=" ");
  inStr <- gsub("[^[:alpha:][:space:][:punct:]]", "", inStr);
  
  # Then convert to a Corpus
  inStrCrps <- VCorpus(VectorSource(inStr))
  
  # Convert the input sentence to lower case,Remove punctuations, numbers, white spaces
  # non alphabets characters this will help improve the match as the dataframe is already cleansed.
  inStrCrps <- tm_map(inStrCrps, content_transformer(tolower))
  inStrCrps <- tm_map(inStrCrps, removePunctuation)
  inStrCrps <- tm_map(inStrCrps, removeNumbers)
  inStrCrps <- tm_map(inStrCrps, stripWhitespace)
  inStr <- as.character(inStrCrps[[1]])
  inStr <- gsub("(^[[:space:]]+|[[:space:]]+$)", "", inStr)
  
  # Return the cleansed resulting sentence
  # If the resulting string is empty return empty and string.
  if (nchar(inStr) > 0) {
    return(inStr); 
  } else {
    return("");
  }
}

#-----------------------------------------------------------------------------------------------------------
# Predicting the next word using Katz's Back Off Algorithm
#-----------------------------------------------------------------------------------------------------------
# To predict the next term of the user specified sentence
#
# 1. We start with validating against a Quadgram (if there are at least 3 or more words in the input string). 
#    Matching against the first three words of the quadgram which match the last three words of the user provided 
#    sentence for which we are trying to predict the next word. The Quadgram is already sorted from highest to 
#    lowest frequency.
#    
# 2. If no Quadgram is found, then we back off to a Trigram.Matching the first two words of TriGram 
#    against the last two words of the sentence.The Trigram is already sorted from highest to lowest frequency.
#
# 3. If no Trigram is found, then we back off to a Bigram. Matching the first word of Biram against the 
#    last word of the sentence.The Bigram is already sorted from highest to lowest frequency.
#
# 4. If no Bigram is found, then we back off to Unigram. Matching the most common word with highest frequency.
#    The Unigram is already sorted from highest to lowest frequency.
#
#-----------------------------------------------------------------------------------------------------------
PredNextTerm <- function(inStr)
{
  assign("mesg", "in PredNextTerm","Wordcloud_Flag", envir = .GlobalEnv)
 
  # Clean up the input string and extract only the words with no leading and trailing white spaces
  inStr <- CleanInputString(inStr);
  
  # Split the input string across white spaces and then extract the length
  inStr <- unlist(strsplit(inStr, split=" "));
  inStrLen <- length(inStr);
  
  nxtTermFound <- FALSE;
  predNxtTerm <- as.character(NULL);
  mesg <<- as.character(NULL);
  # 1. First test the Quadgram using the Quadgram data frame
  if (inStrLen >= 3 & !nxtTermFound)
  {
    # Assemble the terms of the input string separated by one white space each
    inStr1 <- paste(inStr[(inStrLen-2):inStrLen], collapse=" ");
    
    # Subset the Quadgram data frame 
    searchStr <- paste("^",inStr1, sep = "");
    quadgramTemp <- quadgram_data_save[grep (searchStr, quadgram_data_save$terms), ];
    
    # Check to see if any matching record returned
    if ( length(quadgramTemp[, 1]) > 1 )
    {
      predNxtTerm <- quadgramTemp[1,1];
      nxtTermFound <- TRUE;
      mesg <<- "Next word is predicted using a Quadgram."
    }
    quadgramTemp <- NULL;
  }
  
  # 2. Next test the Trigram using the Trigram data frame
  if (inStrLen >= 2 & !nxtTermFound)
  {
    # Assemble the terms of the input string separated by one white space each
    inStr1 <- paste(inStr[(inStrLen-1):inStrLen], collapse=" ");
    
    # Subset the Trigram data frame 
    searchStr <- paste("^",inStr1, sep = "");
    trigramTemp <- trigram_data_save[grep (searchStr, trigram_data_save$terms), ];
    
    # Check to see if any matching record returned
    if ( length(trigramTemp[, 1]) > 1 )
    {
      predNxtTerm <- trigramTemp[1,1];
      nxtTermFound <- TRUE;
      mesg <<- "Next word is predicted using a Trigram."
    }
    trigramTemp <- NULL;
  }
  
  # 3. Next test the Bigram using the Bigram data frame
  if (inStrLen >= 1 & !nxtTermFound)
  {
    # Assemble the terms of the input string separated by one white space each
    inStr1 <- inStr[inStrLen];
    
    # Subset the Bigram data frame 
    searchStr <- paste("^",inStr1, sep = "");
    bigramTemp <- bigram_data_save[grep (searchStr, bigram_data_save$terms), ];
    
    # Check to see if any matching record returned
    if ( length(bigramTemp[, 1]) > 1 )
    {
      predNxtTerm <- bigramTemp[1,1];
      nxtTermFound <- TRUE;
      mesg <<- "Next word is predicted using a Bigram.";
    }
    bigramTemp <- NULL;
  }
  
  # 4. If no next term found in all of the above then return the most
  #    frequently used term from the Unigram using the Unigram data frame
  if (!nxtTermFound & inStrLen > 0)
  {
    predNxtTerm <- unigram_data_save$terms[1];
    mesg <- "Sorry we were not able to find a word matching your sentence,Next word is predicted using a Unigram."
  }
  
   nextTerm <- word(predNxtTerm, -1);
  
  if (inStrLen > 0){
    dfTemp1 <- data.frame(nextTerm, mesg);
    return(dfTemp1);
  } else {
    nextTerm <- "";
    mesg <-"";
    dfTemp1 <- data.frame(nextTerm, mesg);
    return(dfTemp1);
  }
}

#-----------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------
# The Predict Next TermCloud function prepares the data set for the Shiny App to render based on the users input string.
# It does not build a data set for Unigrams. The calling parameters are the input string and it also calls
# the clean input string function. It returns the data formatted for plotting the word cloud.
#-----------------------------------------------------------------------------------------------------------
PredNextTermCloud <- function(inStr,quadterms_1,triterms_1,biterms_1)
{
  #assign("Wordcloud_Flag", envir = .GlobalEnv)
  # Clean up the input string and extract only the words with no leading and trailing white spaces
  inStr <- CleanInputString(inStr);
  
  # Split the input string across white spaces and then extract the length
  inStr <- unlist(strsplit(inStr, split=" "));
  inStrLen <- length(inStr);
  if (inStrLen >= 3 )
  {
    # 1. First test the Quadgram using the Quadgram data frame
    # Assemble the terms of the input string separated by one white space each
    inStr1 <- paste(inStr[(inStrLen-2):inStrLen], collapse=" ");
    # Subset the Quadgram data frame 
    searchStr <- paste("^",inStr1, sep = "");
    quadterms_2 <- quadgram_data_save[grep (searchStr, quadgram_data_save$terms),];
    quadterms_1 <- quadterms_2
    dark2 <- brewer.pal(6, "Dark2")   
    return(quadterms_1)
  }
  
  # 2. Next test the Trigram using the Trigram data frame
  # Assemble the terms of the input string separated by one white space each
  if (inStrLen >= 2){
    inStr1 <- paste(inStr[(inStrLen-1):inStrLen], collapse=" ");
    # Subset the Trigram data frame 
    searchStr <- paste("^",inStr1, sep = "");
    triterms_2 <- trigram_data_save[grep (searchStr, trigram_data_save$terms),];
    triterms_1 <- triterms_2
    dark2 <- brewer.pal(6, "Dark2")   
    return(triterms_1)
  }
  
  # 3. Next test the Bigram using the Bigram data frame
  # Assemble the terms of the input string separated by one white space each
  inStr1 <- inStr[inStrLen];
  # Subset the Bigram data frame 
  if (inStrLen >= 1){
    searchStr <- paste("^",inStr1, sep = "");
    biterms_2 <- bigram_data_save[grep (searchStr, bigram_data_save$terms),];
    biterms_1 <- biterms_2
    dark2 <- brewer.pal(6, "Dark2")
    return(biterms_1)
  }
  
}

msg <- ""