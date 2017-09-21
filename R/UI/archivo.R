

UIarchivo <- sidebarLayout(
  sidebarPanel(
    fileInput("data", "Carge archivo csv, valores separados por comas",
              accept = c(
                "text/csv",
                "text/comma-separated-values,text/plain",
                ".csv", '.xls',
                '.xlsx', '.txt'),
              buttonLabel = "Subir archivo",
              placeholder = "Seleccione un archivo"
    ),
    tags$hr(),
    
    radioButtons("sep", "Separador",
                 choices = c("Coma" = ",",
                             "Punto y coma" = ";",
                             "Tabulador" = "\t",
                             "Espacio" = " "),
                 selected = ","),
    
    # Input: Select quotes ----
    radioButtons("quote", "Comillas",
                 choices = c("Ninguno" = "",
                             "Comilla simple" = '"',
                             "Comilla doble" = "'"),
                 selected = '"'),
    
    
    checkboxInput("header", "Header", TRUE),

    numericInput('start', 'Inicio:', value = 1),
    numericInput('startPeriod', 'Periodo de inicio:', 1),
    numericInput('frecuency', 'Frecuencia:', 1),
    
    uiOutput("timeSeriesColumns")

  ),
  mainPanel(
    tableOutput("contents")
  )
)
