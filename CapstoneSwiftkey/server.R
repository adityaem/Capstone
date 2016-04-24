##
## Name: Server.R 
## Purpose: Server side scripts for Word Predictor Application 
## Date: April 2016
## Author: AKT
##
#-----------------------------------------------------------------------------------------------------------
# Load Libraries and import helper functions
#-----------------------------------------------------------------------------------------------------------
source("helpers.R")

shinyServer(function(input, output, session) {
            #Calls the Next Word Prediction Function and returns the Next predicted word.
            output$prediction <- renderPrint({
            str2 <- CleanInputString(input$inputString);
            strDF <- PredNextTerm(str2);
            #Invoke the next predicted word.
            input$Predict;
            #Define message string to display on the UI
            msg <<- as.character(strDF[1,2]);
            cat("", as.character(strDF[1,1]))
            cat("\n\t");
            cat("\n\t");
            #Display the N Gram selected for the prediction
            cat("Prediction based on: ", as.character(strDF[1,2]));
            })
            
           # Based on if the user selected to append to their sentence. 
           observe({
              str2 <- CleanInputString(input$inputString);
              strDF <- PredNextTerm(str2);
              input$Predict;
              if ( (input$UpdateSentence ==TRUE)){
              updateTextInput(session,'inputString',
              value = paste(str2,as.character(strDF[1,1]) ))}}) 
           

          # Display the Input Sentence entered by the User                  
          output$text1 <- renderText({
          
          str2 <- CleanInputString(input$inputString);
          strDF <- PredNextTerm(str2);
          input$Predict;
          paste("Input Sentence: ", input$inputString)});
          
          # Display the predicted word 
          output$text2 <- renderText({ 
           
            str2 <- CleanInputString(input$inputString);
            strDF <- PredNextTerm(str2);
            input$Predict;
            paste("Predicted Word:",as.character(strDF[1,1]) )
        })
        # Display the N-Gram Used 
        output$text3 <- renderText({ 
          
          str2 <- CleanInputString(input$inputString);
          strDF <- PredNextTerm(str2);
          input$Predict;
          msg <<- as.character(strDF[1,2]);
          paste("N-Gram:",as.character(strDF[1,2]));
          
                   })
        #Display Wordcloud  
        output$plotwordcloud <- renderPlot({
          str2 <- CleanInputString(input$inputString);
          strDF <- PredNextTerm(str2);
          strDF1 <- PredNextTermCloud(str2);
          input$Predict;
          # If more than one match is found then render the word cloud. 
          if (length(strDF1$terms) > 0 && !is.na(strDF1$terms)){
            dark2 <- brewer.pal(6, "Dark2") 
            wordcloud(words = strDF1$terms, freq = strDF1$freq,colors=dark2, scale=c(3,0.2),min.freq = input$freq,max.words = input$max)
          }
        })
          # Render the top three matches based on the N-Gram used. If no match displays empty grid.
                  
        output$plotbar <- renderPlot({
          str2 <- CleanInputString(input$inputString);
          strDF <- PredNextTerm(str2);
          strDF1 <- PredNextTermCloud(str2);
          input$Predict;
          # If more than one match is found then render the word cloud. 
          if (length(strDF1$terms) > 0 && !is.na(strDF1$terms)){
            library(ggplot2)               
             p <- ggplot(strDF1[1:25,], aes(x=reorder(terms,freq), freq))   
             p <- p +labs(y='Frequency',x='Terms')
             p <- p + geom_bar(stat="identity")   
             p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
             p  
          }
        })
    }
)