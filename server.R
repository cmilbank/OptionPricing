

server <- function(input, output) {
  
  values <- reactiveValues()
  observe({
#    input$action_Calc
    
#create data frame
    Data <- data.frame("rand" = runif(input$n))
    Data$type <- input$type
    
#calculate sigma for time period
    values$sigma <- input$sigma_annual*sqrt(input$time)
    
#calculate Laplace parameters
    values$b_annual <- input$sigma_annual/sqrt(2)
    values$b <- values$sigma/sqrt(2)
    values$u <- input$mu_annual*input$time
    
#calculate Black-Scholes amount
    values$BS_price <- format(round(Black_Scholes(0, input$current, input$risk_free, input$sigma_annual, 
                                           input$strike, input$time, input$type), 2), nsmall = 2)
    
#Calculate Laplace stock return
    Data$Laplace <- values$u - values$b*sign(Data$rand - .5)*log(1-2*abs(Data$rand - .5)) + 1
    Data$Stock <- pmax(round(input$current*Data$Laplace, 2), 0)
    
#Apply parameters to data frame    
    Data$strike <- input$strike
    Data$type <- input$type
    
#Calculate option price    
    Data$Option <- ifelse(Data$type == "put", pmax(Data$strike - Data$Stock, 0), 
                   ifelse(Data$type == "call", pmax(Data$Stock - Data$strike, 0), "N/A"))
    values$option_price <- format(round(mean(Data$Option), 2), nsmall = 2)
  })
  
  # Reactive expression to create data frame of all input values ----
  sliderValues <- reactive({
    
    data.frame(
      Option = c(#"Current price",
               #"Strike price",
               #"Time until expiration",
               #"Option Type",
               #"Mu (annual)",
               #"Sigma (annual)",
               #"Risk-free rate (annual)",
               #"Number of simulations",
               #"Sigma",
               #"b (annual)",
               #"b",
               #"Mu",
               "Laplace (simulated)",
               "Black-Scholes"),
      Price = as.character(c(#input$current,
                             #input$strike,
                             #input$time,
                             #input$type,
                             #input$mu_annual,
                             #input$sigma_annual,
                             #input$risk_free,
                             #input$n,
                             #values$sigma,
                             #values$b_annual,
                             #values$b,
                             #values$u,
                             values$option_price,
                             values$BS_price)),
      stringsAsFactors = FALSE)
    
  })
  
# Show the values in an HTML table ----
  output$values <- renderTable({
    sliderValues()
  })
  
  
# Create histogram
  
  output$Hist <- renderPlot({
    histogramdata <- pmax(round(input$current*(values$u - values$b*sign(runif(input$n) - .5)*log(1-2*abs(runif(input$n) - .5)) + 1), 2), 0)
    hist(histogramdata, main = "Laplace simulated stock prices", xlab = "Underlying stock price at expiration")
    abline(v = input$strike, col = "red")
           })
  
}