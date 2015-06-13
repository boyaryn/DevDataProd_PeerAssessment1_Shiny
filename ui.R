 library(shiny)
 
 uni.data <- read.csv("world_university_rankings_2010_2015.csv", sep = ";")
 
 shinyUI(
  navbarPage('University Rankings',
   tabPanel('Application',
    sidebarLayout(
     sidebarPanel(
      uiOutput('locations'),
      uiOutput('institutions'),
	  uiOutput('years')
     ),
	 mainPanel(
	  plotOutput('plot'),
	  textOutput('prediction')
     )
    )
   ),
   tabPanel('Documentation',
    mainPanel(
	 h4('What is University Rankings'),
     p('University Rankings is an application for predicting scores in rankings of the most popular world\'s universities in 2016-2020.'),
	 h4('Usage'),
	 p('For prediction, on the Application tab choose a country of your choice in the Location drop-down list, then a university from the Institution list and move the slider to the year at the end of which you would like to know the predicted score.'),
	 p('On the right side you can see available scores of the chosen university plotted on a graph. These are being used for forecasting.'),
	 p('Below is the predicted score.'),
	 h4('Disclaimer'),
	 p('The application gives a very rough score, so full responsibility for the consequences of using it is on you.'),
	 h4('About the Author'),
	 p('The application is developed in short time frame by software engineer Ivan Boyaryn. If you would like to contact me, find me on LinkedIn.')
    )
   )
  )
 )