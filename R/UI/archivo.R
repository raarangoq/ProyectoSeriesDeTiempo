

UIarchivo <- sidebarPanel(
  
    selectInput("dataType", "Tipo de datos",
                c("Leer archivo", "Aleatorios")
    ),
    conditionalPanel(
      condition = "input.dataType == 'Leer archivo'",
      fileInput("data", "Carge archivo csv, valores separados por comas",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv", '.xls',
                  '.xlsx', '.txt', '.dat'),
                buttonLabel = "Subir archivo",
                placeholder = "Seleccione un archivo"
      ),
      tags$hr(),
      
      radioButtons("sep", "Separador",
                   choices = c("Coma" = ",",
                               "Punto y coma" = ";",
                               "Tabulador" = "\t",
                               "Espacio" = " ",
                               "Un dato por línea" = '\n'),
                   selected = ","),
      
      # Input: Select quotes ----
      radioButtons("quote", "Comillas",
                   choices = c("Ninguno" = "",
                               "Comilla simple" = '"',
                               "Comilla doble" = "'"),
                   selected = '"'),
      
      
      checkboxInput("header", "Header", TRUE)
      
      
    ),
    uiOutput("timeSeriesColumns"),
    
    numericInput('start', 'Inicio:', value = 1),
    numericInput('startPeriod', 'Periodo de inicio:', 1),
    numericInput('frecuency', 'Frecuencia:', 1)
)


UItabla <- tableOutput("contents")

