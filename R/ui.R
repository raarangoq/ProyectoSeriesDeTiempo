

source("R/UI/archivo.R")
source("R/UI/graficar.R")
source("R/UI/resumen.R")


ui <- fluidPage(
  titlePanel("ARC 0.1"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    UIarchivo
    ,
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
          tabPanel("Tabla",  UItabla),
          tabPanel("Graficar", UIgraficar),
          tabPanel("Resumen",  UIresumen)
      )
    )
  )
)

