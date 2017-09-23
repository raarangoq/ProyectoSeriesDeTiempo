
library(shiny)

source("R/server.R")
source("R/ui.R")

regresion <- NULL

prueba <- function(){
  runApp(app)
}

app <- shinyApp(ui, server)


