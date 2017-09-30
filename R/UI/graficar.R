UIgraficar <- {
  list(
    uiOutput("timeSeriesColumns"),
    plotOutput("distPlot")
  )
}


UIestadisticos <- {
  list(
    uiOutput("estatisticsColumnsSelect"),
    plotOutput("acf"),
    plotOutput("pacf")
  )
}

UIdescomposicion <- {
  list(
    uiOutput("descomposeColumnsSelect"),
    plotOutput("descompose")
  )
}

UItendencia <- {
  list(
    uiOutput("regressionColumnsSelect"),
    selectizeInput('typeRegression', 
                   'Tipo de regresión:',
                   # , "Exponencial" , "AR"
                   choices = c("Lineal", "Cuadrática", "Cúbica", "Loess", "Holt-Winters"), 
                   multiple = FALSE),
    numericInput('confidence', "Intervalo de confianza", value = 0.95, min = 0.05, max = 0.9999, step = 0.0001),
    plotOutput("regressionPlot"),
    verbatimTextOutput("regressionParameters"),
    plotOutput("residualPlot")

  )
}

UIpronostico <-{
  list(
    uiOutput("forecastColumnsSelect"),
    selectizeInput('forecastRegression', 
                   'Tipo de regresión:',
                   # , "Exponencial"
                   choices = c("Lineal", "Cuadrática", "Cúbica", "Loess", "Holt-Winters"), 
                   multiple = FALSE),
    sliderInput('percentil', "Porcentaje de datos para entrenar", 
                 value = 80, min = 50, max = 90),
    plotOutput("forecastPlot"),
    verbatimTextOutput("accuracyForecast")
  )
}

