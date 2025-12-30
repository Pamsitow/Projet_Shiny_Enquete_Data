# ---
# global.R
# ---

# 1. Chargement des packages
# Les bases
library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(forcats) # Pour trier les graphiques

# Les packages pour le design et l'interactivité (Exemple Allociné)
library(shinythemes) # Pour changer le look de l'app (ex: thème bleu, gris...)
library(plotly)      # Pour rendre les graphiques interactifs (souris, zoom)
library(ggiraph)     # Autre option pour l'interactivité (on le charge au cas où)
library(kableExtra)  # Pour faire de beaux tableaux HTML

# 2. Chargement des données
data_A_questions <- read_csv2("data/enquete_data_A4_A5_A6_processed.csv")
data_B2_outils   <- read_csv2("data/enquete_data_B2_processed.csv")


# 3. Définition des listes pour les menus déroulants (Inputs)
# Liste pour le choix de la question
list_questions <- list(
  "A4 : Secteur d'activité" = "A4_secteur",
  "A5 : Télétravail" = "A5_teleravail",
  "A6 : Années d'expérience" = "A6_experience",
  "B2 : Fréquence des outils" = "B2_outils"
)

# Liste pour le choix du poste (Filtre)
list_postes <- list(
  "Tous les postes" = "Tous",
  "Data Analyst" = "Data Analyst",
  "Data Scientist" = "Data Scientist",
  "Data Engineer" = "Data Engineer"
)

# Liste pour le choix du genre (Filtre)
list_genres <- list(
  "Tous les genres" = "Tous",
  "Un homme" = "Un homme",
  "Une femme" = "Une femme"
)

# Ordre d'affichage pour la fréquence (Question B2)
levels_frequence <- c("Jamais", "Occasionnellement", "Régulièrement")