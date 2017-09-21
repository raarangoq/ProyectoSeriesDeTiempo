

source("R/Server/Sarchivo.R")
source("R/Server/Sgraficar.R")

server <- function(input, output) {
  # UIarchivo
  output$contents <- renderTable({
    Sarchivo(input)
  })
  
  output$timeSeriesColumns <- renderUI({
    if(!is.null(input$data) && !is.null(input$sep) && !is.null(input$quote) && !is.null(input$header))
      return(selectInput("column", "Columna:", choices = columns))
  })
  

  # UIgraficar
  output$distPlot <- renderPlot({
    
    #Sgraficar(input)
    if (!is.null(timeSerie) && !is.null(input$column)){
      plot(timeSerie, col = 'blue')
      grid(col = 'black')
    }
  })

  #UIresumen
  output$summary <- renderPrint({
    summary(arreglo)
  })
}
