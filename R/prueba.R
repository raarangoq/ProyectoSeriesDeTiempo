
library(shiny)

source("R/server.R")
source("R/ui.R")

arreglo <- c()
file <- NULL

prueba <- function(x){
  arreglo <<- x
  runApp(app)
}

app <- shinyApp(ui, server)


