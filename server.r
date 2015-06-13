 library(shiny)
 library(ggplot2)
 library(splines)
 
 uni.data <- read.csv("world_university_rankings_2010_2015.csv", sep = ";")
 uni.data$endYear <- as.integer(substr(uni.data$Year, 6, 9))
 all.locations <- levels(uni.data$Location)
 
 shinyServer(
  function(input, output) {
   output$locations <- renderUI(
    selectInput('location', 'Location', c(all.locations)),
   )
   output$institutions <- renderUI({
    relevant.locations <- as.character(uni.data[uni.data$Location == input$location,]$Institution)
    selectInput('institution', 'Institution', c(relevant.locations[order(relevant.locations)]), 1)
   })
   output$years <- renderUI(
	sliderInput('year', 'Year', value = 2016, min = 2016, max = 2019, step = 1, sep = '')
   )
   output$plot <- renderPlot({
    g <- ggplot(subset(uni.data, Institution == input$institution), aes(endYear, Score))
    g + geom_point(size = 5) + xlab('Year') + ggtitle('Recent Rating(s)')
   })
   output$prediction <- renderText({
    relevant.scores <- subset(uni.data, Institution == input$institution, c('endYear', 'Score'))
	n.points <- dim(relevant.scores)[1]
	if (n.points > 2) {
	 if (n.points > 3) {
      bsBasis <- bs(relevant.scores$endYear, df = n.points-2)
	  fit <- lm(Score ~ bsBasis, data=relevant.scores)
	 } else {
	  fit <- lm(Score ~ endYear, data=relevant.scores)
	 }
	 years.to.predict <- data.frame(endYear=2016:2020)
	 result <- predict(fit, newdata=years.to.predict)
	} else {
	 result <- rep_len(mean(relevant.scores$Score), 5)
	}
	result <- pmax(pmin(result, 100), 0)
	paste('Prediction for year ', input$year, ': ', round(result[input$year-2015], digits=1), '.', sep = '')
   })
  }
 )