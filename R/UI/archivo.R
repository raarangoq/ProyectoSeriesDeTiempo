

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
    checkboxInput("header", "Header", TRUE)
  ),
  mainPanel(
    tableOutput("contents")
  )
)
