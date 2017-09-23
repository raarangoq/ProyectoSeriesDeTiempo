

source("R/Server/Sarchivo.R")
source("R/Server/Sgraficar.R")

server <- function(input, output) {
  
  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  file <- reactive({
    
    if(input$dataType == 'Aleatorios'){
      file1 <- data.frame(rnorm(300))
      return(file1)
    }
    else{
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
      
      return (file1)
    }
  })
  
  timeSerie <- function(column){
    t <- ts(
      data = file()[, column], 
      start = c(input$start, input$startPeriod), 
      frequency = input$frecuency )
  }

  # UIarchivo
  output$contents <- renderTable({
    file()
  })
  
  output$timeSeriesColumns <- renderUI({
    file1 <- file()
    if(!is.null(file1) && length(names(file1)) > 0) 
        selectizeInput('column', 'Columnas a graficar', choices = names(file1), multiple = TRUE)
  })
  
  

  # UIgraficar
  output$distPlot <- renderPlot({
    colRandom = c("red", "blue", "black", "green", "orange", "purple", "brown", "pink")
    
    if(!is.null(input$column)) {
      serie <- timeSerie(input$column[1])
      
      minY <- min(file()[, input$column[1]])
      maxY <- max(file()[, input$column[1]])
      if(length(input$column) > 1)
        for (i in 2:length(input$column)){
          if(min(file()[, input$column[i]]) < minY)
            minY <- min(file()[, input$column[i]])
          if(max(file()[, input$column[i]]) > maxY)
            maxY <- max(file()[, input$column[i]])
        }
      
      plot(serie, ylim = c(minY, maxY), col = colRandom[1], lwd = 2, main = "Time serie")
      
      if(length(input$column) > 1)
        for (i in 2:length(input$column)){
          serie <- timeSerie(input$column[i])
        lines(serie, col = colRandom[i], lwd = 2)
        }
      
      legend( "topleft",                
              input$column,             
              lwd = c(2, 2),            
              col = colRandom[1:length(input$column)],   
              bty = "n")                
    }
    
    grid(col = 'black')
  })
  
  # UIestadisticos
  
  output$estatisticsColumnsSelect <- renderUI({
    file1 <- file()
    if(!is.null(file1) && length(names(file1)) > 0) 
      selectizeInput('columnEstatistics', 'Columnas a graficar', choices = names(file1), multiple = FALSE)
  })
  
  output$acf <- renderPlot({
    if(!is.null(input$columnEstatistics)) 
        acf(file()[, input$columnEstatistics], main = "ACF") 
  })
  
  output$pacf <- renderPlot({
    if(!is.null(input$columnEstatistics)) 
      pacf(file()[, input$columnEstatistics], main = "Partial ACF") 
  })

  # UIdescomposicion
  
  output$descomposeColumnsSelect <- renderUI({
    file1 <- file()
    if(!is.null(file1) && length(names(file1)) > 0) 
      selectizeInput('columnDescompose', 'Columnas a graficar', choices = names(file1), multiple = FALSE)
  })
  
  output$descompose <- renderPlot({
    if(!is.null(input$columnDescompose)){
      yt = timeSerie(input$columnDescompose)
      descom = decompose(yt, type = 'additive')
      plot(descom)
    } 
  })
  
  # UITendencia
  
  output$regressionColumnsSelect <- renderUI({
    file1 <- file()
    if(!is.null(file1) && length(names(file1)) > 0) 
      selectizeInput('columnRegresion', 'Columna a aplicar la regresión', choices = names(file1), multiple = FALSE)
  })
  
  
  output$regressionPlot <- renderPlot({
    if(!is.null(input$columnRegresion)){
      yt = timeSerie(input$columnRegresion)
      
      t <- seq(1:length(yt))    
      
      if(input$typeRegression == 'Lineal'){
        m <- lm(formula = yt ~ t)  
      }else if(input$typeRegression == 'Cuadrática'){
        tt <- t*t               
        m  <- lm(formula = yt ~ t + tt)     
      }
      else if(input$typeRegression == 'Cúbica'){
        tt <- t*t 
        ttt <- tt*t
        m  <- lm(formula = yt ~ t + tt + ttt)     
      }
      
      plot(t, yt, type = "o", lwd = 2)
      lines(m$fitted.values, col = "red", lwd = 2)
      legend("topleft",           
            c("Real","Pronóstico"), 
            lwd = c(2, 2),                      
            col = c('black','red'),                 
            bty = "n"
      ) 
      
      output$regressionParameters <- renderPrint({
        m
      })
      
      output$residualPlot <- renderPlot({
        par(mfrow=c(2,2))
        options(repr.plot.width=10, repr.plot.height=6)
        r = m$residuals
        plot(t, r, type='b', ylab='', main="Residuales", col="red")
        abline(h=0,lty=2)               
        plot(density(r), xlab='x', main= 'Densidad residuales', col="red")
        qqnorm(r)               
        qqline(r, col=2)         
        acf(r, ci.type="ma", 60) 
      })
      
    }
  })
  
  

  #UIresumen
  output$summary <- renderPrint({
    summary(file())
  })
}
