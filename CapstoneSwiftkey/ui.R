##
## Name: ui.R 
## Purpose: User Interface script for Word Predictor Shiny Application 
## Date: April 2016
## Author: AKT
##
#-----------------------------------------------------------------------------------------------------------

suppressWarnings(library(shiny))

shinyUI(fluidPage(

        mainPanel(
            
            HTML('<img src="Footer.png", height="100px" style="float:center"/>'),
            HTML ("<BR> <h3>Welcome to the Word Predictor 1.0 Application</h3>
                     <h5>Author:AKT Date: April 2016 </h5>
              <div>
              
              <h5>This application was developed as a part of the Coursera Data Science Capstone. 
                  This application is intended to mimic a similiar experience on a mobile device. 
                  All the user has to do is input a partial sentence and hit the Predict Button. Try 'good', 'good morning' to get started
                  The user also has the ability to control word cloud parameters namely the Maximum Words for the Word Cloud and the Minimum Frequency to be used. 
                  They can also control if they want the predicted word to be appended to their partial sentence by checking the 'Update your sentence with the prediction' check box</h5>
              <BR>
                          
              </div>
                  
                  
                  "),
           
            tabsetPanel(
              tabPanel("Application",  
                                       
              
              fluidRow(Style = "border: 1px solid silver;",HTML(((
                "<BR>  <b> Application Preferences </b> <BR> <BR> "
                )))
                ),
              
              fluidRow(Style = "border: 1px solid silver;",column(4,
              sliderInput("freq",
                          "Minimum Frequency:",
                          min = 1,  max = 50, value = 1)),
              column(4,sliderInput("max",
                          "Maximum Number of Words:",
                          min = 1,  max = 300,  value = 30)),
              column(4,checkboxInput("UpdateSentence", "Update your sentence with the prediction", TRUE))
                             
              ),
              
              fluidRow(Style = "border: 1px solid silver;",HTML(((
                "
                <BR>
                <b> Enter a partial sentence and hit the predict button. </b> <BR> 
                <BR>"
              )))
              ),
              fluidRow(Style = "border: 1px solid silver;",align = "left",
                   column(4,textInput("inputString", NULL,value = "")), 
                   column(2,submitButton("Predict")),
                   column(2,textOutput('text1')),
                   column(2,textOutput('text2')),
                   column(2,textOutput('text3'))
                              ), 
              fluidRow(Style = "border: 1px solid silver;",HTML(((
                "
                <BR>
                <i> If there is only a single prediction then No Wordcloud/Bar Plot will be displayed.The application will always check using the last set of words of the entered sentence. (Last 4 -> Last 3 -> Last 2) </i> <BR>
                <BR>"
              )))
              ),
              
              fluidRow(Style = "border: 1px solid silver;",
                       
                column(6,Style = "border: 1px solid silver;",plotOutput("plotwordcloud")),
                column(6,Style = "border: 1px solid silver;",plotOutput('plotbar'))
                )     
              ),
                       
              tabPanel("Summary",
              fluidRow(Style = "border: 1px solid silver;",HTML(((
              "
            
<h3><span class=bullet>&#x2714;</span>&nbsp;Application Features</h3>
              <div>
              <ul>
              <li class=main>This application will accept partial sentences and predict the next word in the sentence.</li> 
              <li class=main>The application allows users to configure word cloud parameters</li>
              <li class=main>The application allows users to automatically add the predicted word to the sentnce they are constructing</li>
              <li class=main>The application will provide a Wordcloud in context to the word being predicted</li>
              <li class=main>The application will display a bar graph based on the word predicted and it relationship to the top 25 for the category</li>
              </ul>
              </div>
              <h3><span class=bullet>&#x2714;</span>&nbsp;Future Roadmap Application Features</h3>
              <div>
              <ul>
              <li class=main>Allow users to select alternate predictive models via application preferences.</li> 
              <li class=main>Implement caching models where more recent words are more likely to appear again</li>
              <li class=main>Implement Trigger models where recent words trigger other words</li>
              <li class=main>Implement Topic Models and also allow for personalization where the prediction is unique to the user.</li>
              </ul>
              </div>
              <h3><span class=bullet>&#x2714;</span>&nbsp;Approach</h3>
              <div>
              <ul>
              <li>We started with performing exploratory analysis on the data. <a href=https://rpubs.com/adityaem/163650>Analysis and Approach Summary to developing a Predictive Text Analytics Solution for Swiftkey</a>
              <li>Based on our observations we developed an optimum sample set as a source for our corpus.Note our data blend for the current application is [Twitter = 5%,Blogs = 10% and News = 10%].</li>
              <li>Using our combined sampled data set we perform cleansing before we remove sparse terms and tokenize.
                  Cleansing is done using the 'tm' package and we converted upper to lower, removed numbers, removed punctuations, trimmed white space and removed unreadable charactors. 
                  This resulted in a much more relevant corpus. </li>
               <li>After removing sparse terms we tokenized the corpus into unigrams, bigrams, trigrams and quadgams.
              </li>
              <li>To support efficient processing we created four .RDATA tables to store the unigrams, bigrams, trigrams and quadgrams. 
               These are already sorted with the terms with the highest frequency appearing first.</li>
              <li>In the Shiny App we load the four .RDATA tables and we are now able to invoke our prediction function to evelaute and recommend the next word.We are using the Katz's back-off model to predict the next term.</li>
              
              </ul>
              </div>
              
              <h3><span class=bullet>&#x2714;</span>&nbsp;Predictive Model</h3>
              <div>
              <ul>
<li> Predicting the next word using Katz's Back Off Algorithm <a href=https://en.wikipedia.org/wiki/Katz's_back-off_model>Katz 
  Backoff</a>
<ul>
<li>We start with validating against a Quadgram (if there are at least 3 or more words in the input string). 
       Matching against the first three words of the quadgram which match the last three words of the user provided 
       sentence for which we are trying to predict the next word. The Quadgram is already sorted from highest to lowest frequency.
</li>   
<li>If no Quadgram is found, then we back off to a Trigram.Matching the first two words of TriGram 
 against the last two words of the sentence.The Trigram is already sorted from highest to lowest frequency.
</li> 
<li>If no Trigram is found, then we back off to a Bigram. Matching the first word of Biram against the 
 last word of the sentence.The Bigram is already sorted from highest to lowest frequency.
</li> 
<li>If no Bigram is found, then we back off to Unigram. Matching the most common word with highest frequency.
The Unigram is already sorted from highest to lowest frequency.
</li>
</ul>
</ul>
	</div>
	


            <h3><span class=bullet>&#x2714;</span>&nbsp;Limitations</h3>
            <div>
            <ul>
            <li>Limited to three words for sentence as we have a max of quadgrams.</li>
            <li>Graphs and Wordclouds do not work for single value results and unigrams</li>
            <li>Due to memory constraints we are using a very small sample of the data and are also limited to the Katz model as other models proved to be a lot more CPU intesive.</li>
            
            </ul>
            </div>

                 <h3><span class= bullet >&#x2714;</span>&nbsp;References</h3>
                 <div>
                 <ul>
                 <li><a href=https://www.coursera.org/learn/data-science-project/home/welcome> Coursera Data Science Home</a>
	               <li><a href=https://class.coursera.org/nlp/lecture>Coursera - Stanford - Natural Language Processing</a>
	               <li><a href=https://swiftkey.com/en>SwiftKey</a>
	               <li><a href=https://en.wikipedia.org/wiki/N-gram>Wikipedia - <em>n</em>-gram</a>
	               <li><a href=https://en.wikipedia.org/wiki/Katz's_back-off_model>Wikipedia - Katz's back-off model</a>
                 <li><a href=https://rstudio-pubs-static.s3.amazonaws.com/31867_8236987cf0a8444e962ccd2aec46d9c3.html>Basic Text Mining in R</a> </li>
                 <li><a href=http://www.corpora.heliohost.org/aboutcorpus.html>HC Corpora </a></li>
                 <li><a href=https://en.wikipedia.org/wiki/Natural_language_processing>Basics for NLP </a></li>
                 <li><a href=https://cran.r-project.org/web/views/NaturalLanguageProcessing.html>CRAN NLP </a></li>
                 <li><a href=https://www.jstatsoft.org/article/view/v025i05>Text Mining Infrastructure in R  </a></li>
                 <li><a href=http://xpo6.com/list-of-english-stop-words/>List of English Stop Words</a></li>
                 <li><a href=https://github.com/adityaem/Capstone/ >github repository for the Capstone Project</a></li>
                <li><a href=http://www.rdocumentation.org/packages/edgeR/functions/goodTuring/>goodTuring</a></li>
</ul>
                  </div>
                "
              
                
                ))) 
              )
            )
        ))
    
))