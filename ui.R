

#set theme

ui <- fluidPage(theme = shinytheme("spacelab"),
  
  # App title ----
  titlePanel("Laplace Option Pricing Calculator"),
  
  fluidRow(
    column(10, offset = 0,
           p("This tool calculates European option prices (calls and puts) based on simulations from a Laplace
             distribution, which I believe serves as a better estimate of market prices than the lognormal
             distribution assumed in the Black-Scholes formula.")
          )
          ),
  
  fluidRow(
    column(10, offset = 0,
           p("To use this tool simply fill out the parameters in the table on the left and enter the number
             of simulations you would like to run. Due to processing time I would recommend running no more than 5,000,000
             simulations.")
    )
  ),
  
  fluidRow(
    column(10, offset = 0,
           p("The output table will show the option price under the simulated Laplace distribution as well as the traditional
             Black-Scholes option price. A histogram of simulated stock prices from the Laplace distribution is also shown below.
             A red line is shown on the chart at the strike price of the option.")
    )
  ),
  
fluidRow(
    column(10, offset = 0,
           p("Please contact Christian with any questions or comments. I am always open to suggestions!")
           )
           ),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar to demonstrate various slider options ----
    sidebarPanel(
      
      # Input: Numeric ----
      numericInput("current", "Current price:",
                  min = 0, max = 500,
                  value = 100),
      
      # Input: Numeric ----
      numericInput("strike", "Strike price:",
                  min = 0, max = 500,
                  value = 90),
      
      # Input: Numeric ----
      numericInput("time", "Time (in years) until expiration:",
                  min = 0, max = 3,
                  value = 1.0, step = .05),
      
      # Input: List ----
      selectInput("type", "Option type:",
                  c("call", "put")),
      
      # Input: Numeric ----
      numericInput("mu_annual", "Expected return (annual):",
                  min = 0, max = 1,
                  value = 0.05, step = .01),
      
      # Input: Numeric ----
      numericInput("sigma_annual", "Volatility (annual):",
                  min = 0, max = 1,
                  value = 0.25, step = .01),
      
      # Input: Numeric ----
      numericInput("risk_free", "Risk-free rate (annual):",
                  min = 0, max = 1,
                  value = 0.01, step = .01),
      
      # Input: Numeric ----
      numericInput("n", "Number of simulations:",
                  min = 0, max = 1000000000,
                  value = 100000)
      
    ),
    
    
    # Main panel for displaying outputs ----
       mainPanel( 
         #img(src='screenshot_smallest4.png', align = "middle", offset = 0),
    
    # Output: Table summarizing the values entered ----
    tableOutput("values"),
    
    # Output: Histogram
    plotOutput("Hist")
      
      
    )
  )
)
