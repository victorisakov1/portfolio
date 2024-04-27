library(shiny)
library(tidyverse)
library(tidytext)
library(ggplot2)
library(igraph)
library(ggraph)
library(topicmodels)
library(scales)
library(mongolite)
library(Matrix)

# Define server logic
server <- function(input, output) {
  
  
  output$wordFrequencyPlot <- renderPlot({
    
 
  #Plotting visuals correlograms:
  ggplot(frequency, aes(x=proportion, y=`United States`, 
                        color = abs(`United States`- proportion)))+
    geom_abline(color="grey40", lty=2)+
    geom_jitter(alpha=.1, size=2.5, width=0.3, height=0.3)+
    geom_text(aes(label=word), check_overlap = TRUE, vjust=1.5) +
    scale_x_log10(labels = percent_format())+
    scale_y_log10(labels = percent_format())+
    scale_color_gradient(limits = c(0,0.001), low = "darkslategray4", high = "gray75")+
    facet_wrap(~author, ncol=2)+
    theme(legend.position = "none")+
    labs(y= "United States", x=NULL)
})  

  
  output$sentimentAnalysisPlot_USA <- renderPlot({
  
    
  bing_counts %>%
    group_by(sentiment) %>%
    top_n(10) %>%
    ungroup() %>%
    mutate(word = reorder(word, n)) %>%
    ggplot(aes(word, n, fill = sentiment)) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~sentiment, scales = "free_y") +
    labs(y = "Contribution to sentiment", x = NULL) +
    coord_flip()
})  
  
  output$sentimentAnalysisPlot_AUS <- renderPlot({
  
    bing_counts_aus %>%
      group_by(sentiment) %>%
      top_n(10) %>%
      ungroup() %>%
      mutate(word = reorder(word, n)) %>%
      ggplot(aes(word, n, fill = sentiment)) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~sentiment, scales = "free_y") +
      labs(y = "Contribution to sentiment", x = NULL) +
      coord_flip()
})
  
  output$LDA_USA <- renderPlot({
    
    req(input$numTopicsUSA, input$numTopTermsUSA)
    
    
    ap_lda_usa <- LDA(dtm_usa, k=input$numTopicsUSA, control=list(seed=123))
    ap_lda_usa
    topics_usa <- tidy(ap_lda_usa)
    
    top_terms_USA <- topics_usa %>%
      group_by(topic) %>%
      top_n(input$numTopTermsUSA, beta) %>%
      ungroup() %>%
      arrange(topic, -beta)
    
    top_terms_USA

    # Let's plot the term frequencies by topic
    top_terms_USA %>%
      group_by(term) %>%
      mutate(term = reorder_within(term, beta, topic)) %>%
      ggplot(aes(term, beta, fill = factor(topic))) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~topic, scales = "free_y") +
      scale_x_reordered() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))+
      coord_flip()
})
  
  output$LDA_AUS <- renderPlot({
    
    req(input$numTopicsAUS, input$numTopTermsAUS)
    
    ap_lda_aus <- LDA(dtm_aus, k=input$numTopicsAUS, control=list(seed=123))
    ap_lda_aus
    topics_aus <- tidy(ap_lda_aus)
    
    top_terms_AUS <- topics_aus %>%
      group_by(topic) %>%
      top_n(input$numTopTermsAUS, beta) %>%
      ungroup() %>%
      arrange(topic, -beta)
    
    top_terms_AUS
    
    # Let's plot the term frequencies by topic
    top_terms_AUS %>%
      group_by(term) %>%
      mutate(term = reorder_within(term, beta, topic)) %>%
      ggplot(aes(term, beta, fill = factor(topic))) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~topic, scales = "free_y") +
      scale_x_reordered() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))+
      coord_flip()
})
}
