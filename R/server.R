

source("R/Server/Sarchivo.R")
source("R/Server/Sgraficar.R")

server <- function(input, output) {

  # UIarchivo
  output$contents <- renderTable({
    Sarchivo(input)
  })

  # UIgraficar
  output$distPlot <- renderPlot({
    Sgraficar(input)
  })

  #UIresumen
  output$summary <- renderPrint({
    summary(arreglo)
  })
}
