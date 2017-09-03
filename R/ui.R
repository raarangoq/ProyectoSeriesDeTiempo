
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("obs", "Número de rangos (cantidad de barras para el histograma):",
                  min = 5, max = 50, value = 10)
    ),
    mainPanel(plotOutput("distPlot"))
  )
)
