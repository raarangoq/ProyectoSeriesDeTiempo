

source("R/Server/Sarchivo.R")
source("R/Server/Sgraficar.R")

server <- function(input, output) {
  
  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  file <- reactive({
    # input$data will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    inFile <- input$data
    
    if (is.null(inFile))
      return(NULL)
    
    file1 <<- read.csv(inFile$datapath,
                      header = input$header,
                      sep = input$sep,
                      quote = input$quote)
    
    columns <<- names(file1)
    
    
    return (file1)
  })
  
  timeSerie <- reactive({
    if(!is.null(input$column)) {
      series <- rep(0, length(input$column))
    
      for (i in 1:length(input$column)){
      series[input$column[i]] <- ts(
        data = file()[, input$column[1]], 
        start = c(input$start, input$startPeriod), 
        frequency = input$frecuency )
      }
      
      return (series)
    }
  })
 
  # UIarchivo
  output$contents <- renderTable({
    file()
    #d()
  })
  
  output$timeSeriesColumns <- renderUI({
    if(!is.null(names(file()))) 
     #return(selectInput( "column", "Columna:", choices = names(file()) ))
      selectizeInput('column', 'Columnas a graficar', choices = names(file()), multiple = TRUE)
  })
  

  # UIgraficar
  output$distPlot <- renderPlot({
    #Sgraficar(input)
    #if (!is.null(timeSerie())){
    #  for(serie in timeSerie())
    #    plot(serie, col = 'blue')
    #}
    
    if(!is.null(input$column)) {
      serie <- ts(
        data = file()[, input$column[1]], 
        start = c(input$start, input$startPeriod), 
        frequency = input$frecuency )
      
      minY <- min(file()[, input$column[1]])
      maxY <- max(file()[, input$column[1]])
      if(length(input$column) > 1)
        for (i in 2:length(input$column)){
          if(min(file()[, input$column[i]]) < minY)
            minY <- min(file()[, input$column[i]])
          if(max(file()[, input$column[i]]) > maxY)
            maxY <- max(file()[, input$column[i]])
        }
      
      print(minY)
      print(maxY)
      
      plot(serie, col = 'blue', ylim = c(minY, maxY))
      
      if(length(input$column) > 1)
        for (i in 2:length(input$column)){
          serie <- ts(
            data = file()[, input$column[i]], 
            start = c(input$start, input$startPeriod), 
            frequency = input$frecuency )
        lines(serie, col = 'blue')
        }
    }
    
    grid(col = 'black')
  })

  #UIresumen
  output$summary <- renderPrint({
    summary(file())
  })
}
