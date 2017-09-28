

source("R/Server/Sarchivo.R")
source("R/Server/Sgraficar.R")

library('forecast')

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
      inFile <- input$data
      
      if (is.null(inFile))
        return(NULL)
  
      file1 <<- read.csv(inFile$datapath,
                        header = input$header,
                        sep = input$sep,
                        quote = input$quote,
                        dec = input$dec)
      
      return (file1)
    }
  })
  
  timeSerie <- function(column){
    t <- ts(
      data = file()[, column], 
      start = c(input$start, input$startPeriod), 
      frequency = input$frecuency 
    )
  }

  # UIarchivo
  output$contents <- renderTable({
    head(file())
  })
  
  output$summary <- renderPrint({
    summary(file())
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
      selectizeInput('columnEstatistics', 'Seleccione una columna', choices = names(file1), multiple = FALSE)
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
      selectizeInput('columnDescompose', 
                     'Seleccione una columna a descomponer', 
                     choices = names(file1), 
                     multiple = FALSE)
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

      t = seq(1:length(yt)) 

      lower = rep(0, length(yt))
      upper = rep(0, length(yt))
      
      if(input$typeRegression == 'Lineal'){
        m <- lm(formula = yt ~ t)  
        interval <- confint(m, level = input$confidence)
        lower <- interval[1] + interval[2] * t
        upper <- interval[3] + interval[4] * t
      }
      else if(input$typeRegression == 'Cuadrática'){
        tt <- t*t               
        m  <- lm(formula = yt ~ t + tt)
        interval <- confint(m, level = input$confidence)
        lower <- interval[1] + interval[2] * t + interval[3] * tt
        upper <- interval[4] + interval[5] * t + interval[6] * tt
      }
      else if(input$typeRegression == 'Cúbica'){
        tt <- t*t 
        ttt <- tt*t
        m  <- lm(formula = yt ~ t + tt + ttt)
        interval <- confint(m, level = input$confidence)
        lower <- interval[1] + interval[2] * t + interval[3] * tt + interval[4] * ttt
        upper <- interval[5] + interval[6] * t + interval[7] * tt + interval[8] * ttt
      }
      #else if(input$typeRegression == 'AR'){
      #  m <- ar(file()[, input$columnRegresion])
      #
      #  m$fitted <- file()[, input$columnRegresion] - m$resid
      #  m$resid[is.na(m$resid)] <- 0
      #}
      else if(input$typeRegression == 'Loess'){
        m <- loess(formula = yt ~ t)
        
        pred <- predict(m, se = TRUE)
        z <- qnorm((1 - input$confidence) / 2,lower.tail=FALSE)
        lower <- pred$fit-z*pred$se.fit
        upper <- pred$fit+z*pred$se.fit

      }
      else if(input$typeRegression == 'Holt-Winters'){
        m <- HoltWinters(yt)
      }

      if(input$typeRegression != 'Holt-Winters'){
        plot(t, yt, type = "o", lwd = 1,  
             ylim = c (min(yt, lower), max(yt, upper)))
        
        if(input$typeRegression != 'AR')
          polygon(c(t,rev(t)),c(lower,rev(upper)),col="lightgrey",border=NA)
  
        lines(t, yt, type = "o", lwd = 1)
        lines(m$fitted, col = "red", lwd = 2)
      }
      else{
        plot(m)
      }

      legend("topleft",           
            c("Real",input$typeRegression), 
            lwd = c(2, 2),                      
            col = c('black','red'),                 
            bty = "n"
      ) 

      output$regressionParameters <- renderPrint({
        m
      })
      
      output$residualPlot <- renderPlot({
        if(input$typeRegression != 'Holt-Winters'){
          par(mfrow=c(2,2))
          options(repr.plot.width=10, repr.plot.height=6)
          r = m$resid
          plot(t, r, type='b', ylab='', main="Residuales", col="red")
          abline(h=0,lty=2)               
          plot(density(r), main= 'Densidad residuales', col="red")
          qqnorm(r)               
          qqline(r, col=2)         
          acf(r, ci.type="ma", 60) 
        }
      })
    }
  })
  
  
  #UIpronostico
  
  output$forecastColumnsSelect <- renderUI({
    file1 <- file()
    if(!is.null(file1) && length(names(file1)) > 0) 
      selectizeInput('columnForecast', 'Columna a aplicar la regresión', choices = names(file1), multiple = FALSE)
  })
  
  output$forecastPlot <- renderPlot({
    if(!is.null(input$columnForecast)){
      yt = timeSerie(input$columnForecast)

      t <- seq(1:length(yt)) 
      tPredic <- length(yt):(length(yt) + sqrt(length(yt)))
      ytPredic <- rep(0, length(tPredic))
      
      lower = rep(0, length(ytPredic))
      upper = rep(0, length(ytPredic))
      
      if(input$forecastRegression == 'Lineal'){
        m <- lm(formula = yt ~ t) 
        ytPredic <- predict(m, data.frame(t = tPredic),type="response")
      }
      else if(input$forecastRegression == 'Cuadrática'){
        tt <- t*t               
        m  <- lm(formula = yt ~ t + tt)
        ytPredic <- predict(m, data.frame(t = tPredic, tt = tPredic * tPredic),type="response")
      }
      else if(input$forecastRegression == 'Cúbica'){
        tt <- t*t 
        ttt <- tt*t
        m  <- lm(formula = yt ~ t + tt + ttt)
        ytPredic <- predict(m, data.frame(t = tPredic, tt = tPredic ^ 2, ttt = tPredic ^ 3),type="response")
      }
      else if(input$forecastRegression == 'Loess'){
        m <- loess(formula = yt ~ t, control=loess.control(surface="direct"))
        ytPredic <- predict(m, data.frame(t = tPredic), type="response")
      }
      else if(input$forecastRegression == 'Holt-Winters'){
        m <- HoltWinters(yt)
        ytPredic <- predict(m, length(ytPredic))
      }
      
      for(i in 1:length(ytPredic)){
        lower[i] <- ytPredic[i] - 2*sqrt(i)
        upper[i] <- ytPredic[i] + 2*sqrt(i)
      }
      
      if(input$forecastRegression != 'Holt-Winters'){
        plot(t, yt, type = "o", lwd = 1, xlim= c(0, max(tPredic)), ylim = c (min(yt, lower), max(yt, upper)) )
        polygon(c(tPredic,rev(tPredic)),c(lower,rev(upper)),col="lightgrey",border=NA)
        lines(m$fitted, col = "red", lwd = 2)
      }
      else{
        plot(m, ytPredic)
        #polygon(c(tPredic,rev(tPredic)),c(lower,rev(upper)),col="lightgrey",border=NA)
      }

      lines(tPredic, ytPredic, col = 'blue')
      
      legend("topleft",           
             c("Real",input$forecastRegression, "Predicción"), 
             lwd = c(2, 2),                      
             col = c('black','red', 'blue'),                 
             bty = "n"
      )
      
      output$accuracyForecast <- renderPrint({
        accuracy(m$fit, file()[, input$columnForecast], test = 1:length(yt))
      })
      
    }
  })

}
