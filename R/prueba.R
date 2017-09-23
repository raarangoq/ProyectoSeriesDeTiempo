
library(shiny)

source("R/server.R")
source("R/ui.R")


#file <- NULL
#columns <- NULL
#timeSerie <- NULL

prueba <- function(){
  runApp(app)
}

app <- shinyApp(ui, server)


