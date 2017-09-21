

Sgraficar <- function(input){
  if (!is.null(timeSerie) && 
      !is.null(input$column) &&
      !is.null(input$start) &&
      !is.null(input$startPeriod) &&
      !is.null(input$frecuency)
      ){
    plot(timeSerie, col = 'blue')
  }
  grid(col = 'black')
}
