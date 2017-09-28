
source("R/UI/graficar.R")


ui <- fluidPage(
  titlePanel("ARC 0.1"),
  
  # Menú lateral, donde se carga el archivo de interés, con algunas opciones para este
  sidebarLayout(
    
    sidebarPanel(
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
        
        checkboxInput("header", "Header", TRUE),
        
        selectizeInput('sep', 'Separador', 
            choices = c("Coma" = ",", "Punto y coma" = ";", "Tabulador" = "\t", "Espacio" = " ",
                "Un dato por línea" = '\n'),
            multiple = FALSE
        ),
        
        selectizeInput('dec', 'Decimales', 
                       choices = c("Coma" = ",", "Punto" = "."),
                       multiple = FALSE
        ),
        
        selectizeInput('quote', 'Comillas', 
            choices = c("Ninguno" = "", "Comilla simple" = '"',
                 "Comilla doble" = "'"),
            multiple = FALSE
        )
      ),
      uiOutput("timeSeriesColumns"),
      
      numericInput('start', 'Inicio:', value = 1),
      numericInput('startPeriod', 'Periodo de inicio:', 1),
      numericInput('frecuency', 'Frecuencia:', 1)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
          tabPanel("Datos",  
                   tableOutput("contents"),
                   verbatimTextOutput("summary")
          ),
          tabPanel("Graficar", UIgraficar),
          tabPanel("Descomposición", UIdescomposicion),
          tabPanel("Componentes", UItendencia),
          tabPanel("Pronóstico", UIpronostico),
          tabPanel("Estadísticos", UIestadisticos)
      )
    )
  )
)

