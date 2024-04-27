library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Airbnb Text Analysis Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Word Frequency Analysis", tabName = "word_frequency", icon = icon("chart-bar")),
      menuItem("Sentiment Analysis USA", tabName = "sentiment_analysis_usa", icon = icon("flag-usa")),
      menuItem("Sentiment Analysis Australia", tabName = "sentiment_analysis_aus", icon = icon("globe-asia")),
      menuItem("LDA Topic Modeling USA", tabName = "lda_modeling_usa", icon = icon("braille")),
      menuItem("LDA Topic Modeling Australia", tabName = "lda_modeling_aus", icon = icon("binoculars"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "word_frequency",
              h2("Word Frequency Analysis"),
              plotOutput("wordFrequencyPlot")),
      
      tabItem(tabName = "sentiment_analysis_usa",
              h2("Sentiment Analysis for USA Listings"),
              plotOutput("sentimentAnalysisPlot_USA")),
      
      tabItem(tabName = "sentiment_analysis_aus",
              h2("Sentiment Analysis for Australia Listings"),
              plotOutput("sentimentAnalysisPlot_AUS")),
      
      tabItem(tabName = "lda_modeling_usa",
              h2("LDA Topic Modeling for USA"),
              sliderInput("numTopicsUSA", "Number of Topics (k):", value = 10, min = 2, max = 15, step = 1),
              sliderInput("numTopTermsUSA", "Number of Top Terms (n):", value = 5, min = 1, max = 15, step = 1),
              plotOutput("LDA_USA")),
      
      tabItem(tabName = "lda_modeling_aus",
              h2("LDA Topic Modeling for Australia"),
              sliderInput("numTopicsAUS", "Number of Topics (k):", value = 10, min = 2, max = 15, step = 1),
              sliderInput("numTopTermsAUS", "Number of Top Terms (n):", value = 5, min = 1, max = 15, step = 1),
              plotOutput("LDA_AUS"))
    )
  )
)