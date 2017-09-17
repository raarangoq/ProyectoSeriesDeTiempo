
ui <- fluidPage(

  navbarPage("ARC 0.1",

  tabPanel("Archivo",
   sidebarLayout(
       sidebarPanel(
         fileInput("file1", "Carge archivo csv",
                   accept = c(
                     "text/csv",
                     "text/comma-separated-values,text/plain",
                     ".csv", '.xls',
                     '.xlsx', '.txt', '.R'),
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
   ),# end tabPanel

    tabPanel("Plot",
       sidebarLayout(
         sidebarPanel(
           sliderInput("obs", "Número de rangos (cantidad de barras para el histograma):",
                       min = 5, max = 50, value = 10)
         ),
         mainPanel(plotOutput("distPlot"))
       )

    ), # end tabPanel
    tabPanel("Summary",
             verbatimTextOutput("summary")
    )


  ) # End navPage




)
