server <- function(input, output) {
  output$distPlot <- renderPlot({
    hist(arreglo, breaks = input$obs,
         col = 'darkgray', border = 'white', probability = TRUE,
         main = "Histograma de probabilidad")
    grid(col = 'black')
    lines(density(arreglo), col = 'red')
  })
}
