---
title       : Capstone - Swiftkey Presentation
subtitle    : Word Predictor 1.0
author      : AKT
job         : April 2016
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Introduction & Objectives


- Around the world, people are spending an increasing amount of time on their mobile devices for email, social networking, banking and a whole range of other activities. But typing on mobile devices can be a challenge

- SwiftKey, our corporate partner in this capstone, builds a smart keyboard that makes it easier for people to type on their mobile devices 

- Our goal is to develop a product that will enhance the smart keyboard with integrated predictive analytics


--- .nobackground
## Approach
>1. First exploratory analysis on the data was performed <a href=https://rpubs.com/adityaem/163650>Click to View: Analysis and Approach Summary</a>
>2. Based on the above observations an optimum sample set was developed as a source for the corpus (combining samples of Blogs, News & Twitter data)
>3. The sample data set is then cleansed by using text mining (tm) methods and sparse terms are removed
>4. The clean corpus is then tokenized into unigrams, bigrams, trigrams and quadgams
>5. To support efficient processing four.RDATA tables were created to store the unigrams,bigrams,trigrams and quadgrams to be used by the application
>6. To test & demonstrate the power of the predictive model a Shiny Application called the Word Predictor 1.0 was developed


--- .nobackground
## The Model
The application uses the Katz Back Off Model.It gave the best performance-per-prediction relative to the other models(good turing,Kneser-Ney & interpolated models).

**The essential idea is to back-off to lower order models for zero counts.** 
The equation for Katz's back-off model is:
<img src="https://upload.wikimedia.org/math/f/1/d/f1dffd8b30aee3314d256f166f85f0c9.png" title="plot of chunk simple-plot" alt="plot of chunk simple-plot" style="display: block; margin: auto;" />

1. First start with matching against the first three words of the quadgram with the last three of the input
2. If no Quadgram is found, then we back off to a Trigram
3. If no Trigram is found, then we back off to a Bigram
4. If no Bigram is found, then we back off to Unigram 

--- .nobackground
## Application Features
✔ **Current Application Features**
- This application will accept partial sentences and predict the next word in the sentence
- The application allows users to configure word cloud parameters
- The application allows users to automatically add the predicted word to the sentnce
- The application will provide a Wordcloud in context to the word being predicted
- The application will display a bar graph based on the frequency of the word predicted

✔ **Future Roadmap Application Features**
- Allow users to select alternate predictive models via application preferences
- Implement caching models where more recent words are more likely to appear again
- Implement Trigger models where recent words trigger other words
- Implement Topic Models and also allow for personalization
- Support additional languages outside of English and also language hybrids

--- .nobackground
## Application Tour 
#  <a href=https://adityaem.shinyapps.io/CapSwift/> Click here to see the Application in Action</a>
In Application preferences you can control Wordcloud Parameters & control if next word is automatically added to the sentence.

<img height='100' width = '800' src = 'https://github.com/adityaem/Capstone/blob/13aebb69adcb71a68a0a1c41eccb42a0cdb8368c/AppPreference.png?raw=true' align ="middle"> </img>

Now enter a partial sentence and hit the "Predict" button.If the next word was found & had a more than a single occurance then both Wordclouds and Bar charts will be displayed.

<img height='250' width = '800' src = 'https://github.com/adityaem/Capstone/blob/13aebb69adcb71a68a0a1c41eccb42a0cdb8368c/PredictImage.png?raw=true' align ="middle"> </img>

--- .nobackground
## Conclusions & Next Steps
✔ **Conclusions**
- An application like the Word Predictor 1.0 can help improve communication accuracy and time to respond 
- Using NLP techniques combined with TM and ML the application will be able to help identify and incorporate new language patterns
- Can be integrated into new messaging platforms<a href="http://techcrunch.com/2016/03/17/facebooks-messenger-in-a-bot-store/" > Facebook Bots</a>
- The application can improve significantly if tracking and usage can be enabled (PII concerns are a barrier)

✔ **Next Steps for the Word Predictor 1.0**
- Create a Minimum Viable Product for Alpha testing in the field on IOS and Android platforms (90 Days)

--- .nobackground
## Thank you

# Thank you very much for giving me the opportunity to work on this project and present my ideas. 

- <a href=https://github.com/adityaem/Capstone/ >Source code for the Capstone Project</a>

- <a href=https://www.coursera.org/learn/data-science-project/home/welcome> Coursera Data Science Home</a>

- <a href=https://adityaem.shinyapps.io/CapSwift/> The Word Predictor 1.0 In Action (Capstone Shiny App)</a>

- <a href=http://rpubs.com/adityaem/175198> Capstone Final Presentation (Capstone Shiny App)</a>


