UIgraficar <- {
  list(
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
                   choices = c("Lineal", "Cuadrática", "Cúbica"), 
                   multiple = FALSE),
    plotOutput("regressionPlot"),
    verbatimTextOutput("regressionParameters"),
    plotOutput("residualPlot"),
    
    selectizeInput('randomWalk', 
                   'Paseo aleatorio', 
                   choices = c("Lineal", "Cuadrática", "Cúbica", "Global"), 
                   multiple = FALSE),
    plotOutput("randomWalkPlot")
  )
}

