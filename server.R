library(shiny)#création application shiny
library(dplyr)#traitement de données tidyverse
library(ggplot2)#graphs tidyverse
library(forcats)# manipulation de facteurs

server <- function(input, output) {
  
  # 1/ LOGIQUE POUR LES QUESTIONS A4, A5, A6
  
  # Filtre des données
  data_A_filtered <- reactive({
    data_filtree <- data_A_questions
    
    if (input$choix_poste != "Tous") {
      data_filtree <- data_filtree %>% filter(new_poste == input$choix_poste)
    }
    
    if (input$choix_genre != "Tous") {
      data_filtree <- data_filtree %>% filter(Y1A_genre == input$choix_genre)
    }
    
    return(data_filtree)
  })
  
  # Calcul des effectifs
  data_A_to_display <- reactive({
    req(input$choix_question) # Sécurité : attend que l'input soit chargé
    
    data_A_filtered() %>%
      mutate(Categorie_Temp = as.character(!!sym(input$choix_question))) %>%
      group_by(Categorie = Categorie_Temp) %>%
      summarise(Effectif = n()) %>%
      mutate(Pourcentage = round(100 * Effectif / sum(Effectif), 1)) %>%
      arrange(desc(Effectif)) %>%
      filter(!is.na(Categorie))
  })
  
  # Titre dynamique
  output$titre_graphique_A <- renderText({
    if (input$choix_question == "A4_secteur") {
      "Analyse de la question A4 : Secteur d'activité"
    } else if (input$choix_question == "A5_teleravail") {
      "Analyse de la question A5 : Télétravail"
    } else if (input$choix_question == "A6_experience") {
      "Analyse de la question A6 : Années d'expérience"
    } else {
      "Analyse des données"
    }
  })
  
  # Graphique A
  output$plot_question_A <- renderPlot({
    data_plot <- data_A_to_display()
    
    ggplot(data_plot, aes(x = fct_reorder(Categorie, Effectif), y = Effectif, fill = Categorie)) +
      geom_col() +
      coord_flip() +
      labs(x = "", y = "Nombre de répondants") +
      theme_minimal() +
      theme(legend.position = "none")
  })
  
  # Tableau A
  output$table_question_A <- renderTable({
    data_A_to_display()
  })
  
  
  # 2/ LOGIQUE POUR LA QUESTION B2

  
  # Filtre B2
  data_B2_filtered <- reactive({
    data_filtree <- data_B2_outils
    
    if (input$choix_poste != "Tous") {
      data_filtree <- data_filtree %>% filter(new_poste == input$choix_poste)
    }
    
    if (input$choix_genre != "Tous") {
      data_filtree <- data_filtree %>% filter(Y1A_genre == input$choix_genre)
    }
    
    return(data_filtree)
  })
  
  # Calcul B2
  data_B2_to_display <- reactive({
    # On définit l'ordre logique des fréquences pour le graphique
    levels_frequence <- c("Jamais", "Occasionnellement", "Régulièrement")
    data_B2_filtered() %>%
      count(Outil, Frequence) %>%
      mutate(Frequence = factor(Frequence, levels = levels_frequence))
  })
  
  # Graphique B2
  output$plot_question_B2 <- renderPlot({
    data_plot <- data_B2_to_display()
    
    ggplot(data_plot, aes(x = Frequence, y = n, fill = Frequence)) +
      geom_col() +
      facet_wrap(~ Outil, scales = "free_y") +
      labs(title = "Fréquence d'utilisation par outil", x = "", y = "Effectif") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Tableau B2
  output$table_question_B2 <- renderTable({
    data_B2_to_display()
  })
}