#packages

library(readr) # chargement fichiers tidyverse
library(dplyr) #traitement de données tidyverse
library(readxl) # importation fichier excel tidyverse
library(lubridate) #dates :tidyverse
library(ggplot2) #graphs tidyverse
library(tidyr) # mise en forme des données

# importation fichier csv
data_enquete <- read_csv2("data/enquete_data_raw.csv")

#aperçu variable numérique
summary(data_enquete)

#structure des données
glimpse(data_enquete)

#On applique les filtres demandés dans les fonctionnalités attendues
data_filtree <- data_enquete %>%
  filter(
    # Exclusion des étudiants
    A2_statut != "Etudiant (hors alternance / stage)",
    
    # Exclusion des personnes en recherche d'emploi
    A2_statut != "En recherche d'emploi",
    
    # Exclusion des postes "Autres"
    A3_poste != "Autre"
  )
#On fait 2 vérifications pour pouvoir différencier le cas autre dans statut/poste
count(data_filtree, A2_statut)
count(data_filtree, A3_poste)


#On renomme la variable chargé d'études en data analyst 
# et on renomme la variable statisticien en data scientist
#On crée une nouvelle colonne new_poste pour voir les 3 postes data
data_filtree <- data_filtree %>%
  mutate(
    new_poste = case_when(
      A3_poste == "Chargé d’études / chargé d’études statistiques" ~ "Data Analyst",
      A3_poste == "Data Analyst / analyste" ~ "Data Analyst",
      A3_poste == "Statisticien" ~ "Data Scientist",
      A3_poste == "Data Scientist" ~ "Data Scientist",
      A3_poste == "Data Engineer" ~ "Data Engineer",
      
      # On met NA aux autres postes pour les exclure
      TRUE ~ NA_character_
    )
  ) %>%
# On ne garde que les nouveaux postes dans la colonne new_poste
  filter(!is.na(new_poste))

# Vérification
count(data_filtree, new_poste)

# Nous sélectionons les colonnes utiles pour répondre aux questions A4/A5/A6
data_A4_A5_A6 <- data_filtree %>%
  select(
    id,
    new_poste,
    Y1A_genre,
    A4_secteur,
    A5_teleravail,
    A6_experience
  )

glimpse(data_A4_A5_A6)

#ensuite nous regroupons toutes les sous catégories de B2
data_B2 <- data_filtree %>%
  select(
    id,
    new_poste,
    Y1A_genre,
    #Vu que toutes les catégories de B2 ont le même début syntaxique, on utilise
    # start_with pour pouvoir avoir un code plus léger, au lieu de prendre les
    # différentes colonnes une à une comme fait avant
    starts_with("B2_frequence_utilisation_")) %>%
  # On pivote les données du format large au format long pour avoir un tableau
  # plus lisible et pratique pour l'application shiny
  pivot_longer(
    cols = starts_with("B2_frequence_utilisation_"),
    names_to = "Outil",
    values_to = "Frequence"
  ) %>%
  # on enlève le préfixe pour avoir un menu déroulant plus propre sur shiny
  mutate(
    Outil = sub("B2_frequence_utilisation_", "", Outil),
    
    # On remplace les NA par Jamais
    Frequence = replace_na(Frequence, "Jamais")
  )

#vérification
count(data_B2, Outil, Frequence)

# 6. Sauvegarde des données préparées (Optionnel mais recommandé)
# ---

# Ces fichiers seront plus légers et propres à charger dans l'application Shiny

# Données pour les questions A4, A5, A6
write_csv2(data_A4_A5_A6, "data/enquete_data_A4_A5_A6_processed.csv")

# Données pour la question B2
write_csv2(data_B2, "data/enquete_data_B2_processed.csv")