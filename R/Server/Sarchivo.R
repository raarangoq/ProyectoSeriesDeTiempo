

Sarchivo <- function(input){
  # input$data will be NULL initially. After the user selects
  # and uploads a file, it will be a data frame with 'name',
  # 'size', 'type', and 'datapath' columns. The 'datapath'
  # column will contain the local filenames where the data can
  # be found.
  inFile <- input$data

  if (is.null(inFile))
    return(NULL)

  file <<- read.csv(inFile$datapath,
                 header = input$header,
                 sep = input$sep,
                 quote = input$quote)
  
  columns <<- names(file)
  
  if(!is.null(input$column) == TRUE && is.numeric(file[, input$column])){
    timeSerie <<- ts(
      data = file[, input$column], 
      start = c(input$start, input$startPeriod), 
      frequency = input$frecuency
    )
  }
  return (file)
}

