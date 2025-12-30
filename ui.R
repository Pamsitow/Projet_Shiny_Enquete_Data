library(shiny)

fluidPage(
  theme = shinytheme("cerulean"), #choix du thème

    # Application titre
    titlePanel("Analyse de l'enquête data"),
  

    # Barre latérale avec un bouton de choix du genre
    sidebarLayout(
        sidebarPanel(
          h4("Filtres de l'application"),
          
          #Filtre 1: Choix de la question 
          selectInput(
            inputId = "choix_question",
            label = "1. Choisir la question à afficher :",
            choices = list_questions,
            selected = "A4_secteur"
          ),
          
          #Filtre 2: Choix du poste
          selectInput(
            inputId = "choix_poste",
            label = "2. Filtrer par poste :",
            choices = list_postes,
            selected = "Tous"
          ),
          
          #Filtre 3: Choix du genre
          selectInput(
            inputId = "choix_genre",
            label = "3. Filtrer par genre :",
            choices = list_genres,
            selected = "Tous"
          ),
          
          #Logo Data
          img(src = "logo_data.jpg", height = "200x"),
        ),
        
        
        
        mainPanel(
          # Affichage du graphique des réponses au questions A4, A5, A6
          conditionalPanel(
            condition = "input.choix_question != 'B2_outils'",
            h3(textOutput("titre_graphique_A")), #titre dynamique
            plotOutput("plot_question_A"),
            hr(),
            h4("Données (effectifs et pourcentages)"),
            tableOutput("table_question_A")  #affichage tableau 
          ),
          
          # Affiche du graphique pour la question B2
          conditionalPanel(
            condition = "input.choix_question == 'B2_outils'",
            #titre B2
            h3("Analyse de la question B2 : Fréquence d'utilisation des outils"),
            plotOutput("plot_question_B2"),
            hr(),
            h4("Données (effectifs)"),
            tableOutput("table_question_B2")  #affichage tableau
          )
        )
    )
)
