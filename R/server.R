server <- function(input, output) {

  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    inFile <- input$file1

    if (is.null(inFile))
      return(NULL)

    file <<- read.csv(inFile$datapath, header = input$header)
  })

  output$distPlot <- renderPlot({
    if (length(file) > 0){
      plot(file$fila1, col = 'blue')
      lines(file$fila2, col = 'red')
    }
    else{
        hist(arreglo, breaks = input$obs,
             col = 'darkgray', border = 'white', probability = TRUE,
             main = "Histograma de probabilidad")
        grid(col = 'black')

        lines(density(arreglo), col = 'red')
      }
  })

  output$summary <- renderPrint({
    summary(arreglo)
  })
}
