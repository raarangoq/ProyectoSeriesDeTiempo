

source("R/UI/archivo.R")
source("R/UI/graficar.R")
source("R/UI/resumen.R")


ui <- fluidPage(
  navbarPage("ARC 0.1",
    tabPanel("Archivo",  UIarchivo),
    tabPanel("Graficar", UIgraficar),
    tabPanel("Resumen",  UIresumen)
  )
)
