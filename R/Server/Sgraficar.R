

Sgraficar <- function(input){
  if (length(file) > 0){
    plot(file$fila1, col = 'blue')
    lines(file$fila2, col = 'red')
  }
  else{
    hist(arreglo, breaks = input$obs,
         col = 'darkgray', border = 'white', probability = TRUE,
         main = "Histograma de probabilidad")
    lines(density(arreglo), col = 'red')
  }

  grid(col = 'black')
}
