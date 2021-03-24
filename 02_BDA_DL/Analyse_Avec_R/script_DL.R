#-----------------------------------------------------#
#                     Groupe 1 
#
#   MOMAS Lisa, FOURNIER Alphonse, TAMANINI Nicolas   
#-----------------------------------------------------#


# Les données d'entrée pour ce projet (notamment co2_resultat.txt ou Catalogue.csv) se situent dans l'archive data_group_1.zip
setwd("C:/data_group_1")


# Installation et activation des packages

install.packages("ggplot2")
install.packages("dplyr")
install.packages("stringr")
install.packages("C50")
install.packages("randomForest")
install.packages("e1071")
install.packages("naivebayes")
install.packages("nnet")
install.packages("kknn")
install.packages("ROCR")
install.packages("pROC")
install.packages("caret")
install.packages("RODBC")

library(ggplot2)
library(dplyr)
library(stringr)
library(C50)
library(randomForest)
library(e1071)
library(naivebayes)
library(nnet)
library(kknn)
library(ROCR)
library(pROC)
library(caret)
library(RODBC)

#------------------------------------------------------------------------------------------------------------#
#  Import des dataframes client, marketing, immatriculations, catalogue depuis une base de données ORACLE SQL      
#------------------------------------------------------------------------------------------------------------#

# Définition de la connexion entre R et la source de données ORCLBIGDATALITEVM_DNS pointant vers la base Oracle SQL de la machine virtuelle BigDataLite.
# Voir le rapport - partie 4 - Chargement des données dans R pour des explications approfondies sur le DNS ORCLBIGDATALITEVM_DNS.
connexion <- odbcConnect("ORCLBIGDATALITEVM_DNS", uid="GROUPE1_PROJET", pwd="GROUPE1_PROJET01", believeNRows=FALSE)

marketing <- sqlQuery(connexion, 'SELECT * FROM marketing_ext ORDER BY CLIENTMARKETINGID')
immatriculations <- sqlQuery(connexion, 'SELECT * FROM immatriculation_ext')
client <- sqlQuery(connexion, 'SELECT * FROM client')
#catalogue <- sqlQuery(connexion, "SELECT * FROM catalogue_ext")

# L'import de la table catalogue échoue à cause de l'erreur ORA-29275 partial multibyte character 
# Par manque de temps, nous avons pas pu régler le problème et avons donc décidé d'importer le data frame catalogue directement depuis Catalogue.csv 

# Les données d'entrée pour ce projet (notamment co2_resultat.txt ou Catalogue.csv) se situent dans l'archive data_group_1.zip

catalogue <- read.csv(
  "Catalogue.csv", 
  header = TRUE, 
  sep = ",", 
  dec = "."
)

names(catalogue)[names(catalogue) == "marque"] <- "MARQUE"
names(catalogue)[names(catalogue) == "nom"] <- "NOM"
names(catalogue)[names(catalogue) == "puissance"] <- "PUISSANCE"
names(catalogue)[names(catalogue) == "longueur"] <- "LONGUEUR"
names(catalogue)[names(catalogue) == "nbPlaces"] <- "NBPLACES"
names(catalogue)[names(catalogue) == "nbPortes"] <- "NBPORTES"
names(catalogue)[names(catalogue) == "couleur"] <- "COULEUR"
names(catalogue)[names(catalogue) == "occasion"] <- "OCCASION"
names(catalogue)[names(catalogue) == "prix"] <- "PRIX"

#--------------------------------------#
#                 CO2     
#--------------------------------------#

# On met toutes les marques en majuscules pour correspondre aux marques présentes dans le fichier resultat_co2.txt issu du MapReduce.
catalogue$MARQUE = toupper(catalogue$MARQUE)
immatriculations$MARQUE = toupper(immatriculations$MARQUE)

# Import du fichier co2_resultat.txt (issu du MapReduce)
# Les données d'entrée pour ce projet (notamment co2_resultat.txt) se situent dans l'archive data_group_1.zip
co2 <- read.delim(
  "co2_resultat.txt", 
  header = TRUE, 
  sep = "\t", 
  dec = "."
)
 
# On nomme les colonnes du data frame co2
colnames(co2) <- c("Marque","Bonus/Malus", "RejetCo2", "cout.energie")

# On effectue la jointure entre les data frames catalogue et co2 par marque de véhicule 
catalogue <- left_join(catalogue, co2, by = c("MARQUE" = "Marque"), copy = FALSE)

View(catalogue)
# Les colonnes "Marque","Bonus/Malus", "RejetCo2", "cout.energie" ont bien été ajoutées au catalogue



#--------------------------------------#
#  1. Analyse exploratoire des données      
#--------------------------------------#



#--------------------------------------#
#               CLIENTS
#--------------------------------------#

# Malgré le nettoyage de la table client sur Oracle SQL, nous avons remarqué qu'elle contenait des lignes incomplètes.
# On a alors décidé de supprimer ces lignes incomplètes avec R.

#    TRI AGE 
# Accepter que les valeurs comprises entre 18 et 84.
client <- client%>% filter(client$AGE %in% (18:84))
client$AGE <- as.numeric(client$AGE)

# TRI TAUX
# Accepter les valeurs comprises entre 544 et 74 185.
client <- client%>% filter(client$TAUX %in% (544:74185))
client$TAUX <- as.numeric(client$TAUX)

# TRI NBENFANTSACHARGE
# Accepte que les valeurs comprises entre 0 et 4
client <- client%>% filter(client$NBENFANTSACHARGE %in% (0:4))
client$NBENFANTSACHARGE <- as.numeric(client$NBENFANTSACHARGE)
qplot(NBENFANTSACHARGE, data=client)

#    TRI SEXE

# Suppression des autres valeurs de sexe (autres que F et M)
client <- subset(client, client$SEXE == "F" | client$SEXE == "M" )
qplot(SEXE, data=client)

#   TRI SITUATION FAMILIALE

# Suppression des autres valeurs non listées dans la catégorie
client <- subset(client, client$SITUATIONFAMILIALE == "Celibataire" | client$SITUATIONFAMILIALE == "En Couple")

# TRI X2EME.VOITURE
#Accepte que les valeurs égale à "true" ou "false"
client <- subset(client, client$DEUXIEMEVOITURE  == "true" | client$DEUXIEMEVOITURE  == "false")

# TRI IMMATRICULATION
# Garder que les plaques d'immatriculations de 10 charactères
client <- client[str_count(client$IMMATRICULATION) == 10,]

# Test pour identifier la présence de doublons
sum(duplicated(client$IMMATRICULATION))

# suppression des lignes dupliquées à l'aide de la librairie dplyr
client <- distinct(client, IMMATRICULATION, .keep_all = TRUE)


#--------------------------------------#
#              CATALOGUE
#--------------------------------------#

# Test pour identifier la présence de doublons

sum(duplicated(catalogue))

# pas de lignes dupliquées 


# Exploration visuelle du tableau de valeurs --> Pas de valeurs manquantes


# Vérification des contraintes de domaine 

# Marque : Affichage des effectifs de la variable marque : 

table(catalogue$MARQUE)

# Pas de marque inconnue


# Nom du véhicule : Affichage des effectifs de la variable nom : 

table(catalogue$NOM)

# Pas de nom inconnu


# Puissance : affichage des statistiques élémentaires de la variable puissance

summary(catalogue$PUISSANCE)

# Les puissances sont bien dans l'intervalle [55,507]


# Longueur : Affichage des effectifs de la variable longueur : 

table(catalogue$LONGUEUR)

# Pas de catégorie de longueur inconnue


# Nombre de places : histogramme des effectifs de la variable nbPlaces

qplot(NBPLACES, data=catalogue, bins=3)

# Bien dans l'intervalle [5,7]



# Nombre de portes : histogramme des effectifs de la variable nbPortes

qplot(NBPORTES, data=catalogue, bins=3)

# Bien dans l'intervalle [3,5]



# Couleur :  Affichage des effectifs de la variable couleur

table(catalogue$COULEUR)

# Pas de couleur inconnue



# Occasion :  Affichage des effectifs de la variable occasion

table(catalogue$OCCASION)

# On a bien que des booléens



# Prix : affichage des statistiques élémentaires de la variable prix

summary(catalogue$PRIX)

# Prix bien dans l'intervalle [7500,101300]


#--------------------------------------#
#           IMMATRICULATIONS
#--------------------------------------#


# Test pour identifier la présence de doublons

sum(duplicated(immatriculations))

# suppression des lignes dupliquées à l'aide de la librairie dplyr

immatriculations <- distinct(immatriculations)


# Remplacer les valeurs mal saisies 
immatriculations$LONGUEUR <- ifelse(immatriculations$LONGUEUR=="tr¿longue", "très longue",immatriculations$LONGUEUR)



# Vérification des contraintes de domaine 


# immatriculation

# Test pour identifier la présence de doublons au sein des numéros d'immatriculations

sum(duplicated(immatriculations$IMMATRICULATION))

# suppression des lignes dupliquées à l'aide de la librairie dplyr

immatriculations <- distinct(immatriculations, IMMATRICULATION, .keep_all = TRUE)


# Format du numéro d'immatriculation

# On souhaite le format Â« 9999 AA 99 Â» qui comprend 10 caractères
# On supprime donc les lignes dont le numéro d'immatriculation est inférieur à 10 caractères

immatriculations <- immatriculations[str_count(immatriculations$IMMATRICULATION) == 10,]


# Marque : Affichage des effectifs de la variable marque : 

table(immatriculations$MARQUE)

# Pas de marque inconnue


# Nom du véhicule : Affichage des effectifs de la variable nom : 

table(immatriculations$NOM)

# Pas de nom inconnu



# Puissance : affichage des statistiques élémentaires de la variable puissance

summary(immatriculations$PUISSANCE)

# Les puissances sont bien dans l'intervalle [55,507]


# Longueur : Affichage des effectifs de la variable longueur : 

table(immatriculations$LONGUEUR)

# Pas de catégorie de longueur inconnue


# Nombre de places : histogramme des effectifs de la variable nbPlaces

table(immatriculations$NBPLACES)

# Bien dans l'intervalle [5,7]



# Nombre de portes : histogramme des effectifs de la variable nbPortes

qplot(NBPORTES, data=immatriculations, bins=3)

# Bien dans l'intervalle [3,5]



# Couleur :  Affichage des effectifs de la variable couleur

table(immatriculations$COULEUR)

# Pas de couleur inconnue



# Occasion :  Affichage des effectifs de la variable occasion

table(immatriculations$OCCASION)

# On a bien que des booléens



# Prix : affichage des statistiques élémentaires de la variable prix

summary(immatriculations$PRIX)

# Prix bien dans l'intervalle [7500,101300]


#--------------------------------------#
#             MARKETING
#-------------------------------------

# On retire la COLONNE CLIENTMARKETINGID
marketing <- marketing[,-1]

marketing <- subset(marketing, marketing$SEXE == "F" | marketing$SEXE == "M" )

# Remplacer les valeurs mal saisies 
marketing$SITUATIONFAMILIALE <- ifelse(marketing$SITUATIONFAMILIALE=="C¿libataire", "Celibataire", marketing$SITUATIONFAMILIALE)




#-----------------------------------------------#
#  2. Identification des catégories de véhicules      
#-----------------------------------------------#


# Création de la colonne catégorie dans le data frame "catalogue"

# Nous pouvons noter que nous n'allons pas prendre en compte les données issues du data frame co2.
# La raison est que le fichier CO2.csv contenait uniquement des véhicules électriques, hybrides et des vans et ces véhicules sont tous des véhicules récents (2020).
# Or, notre catalogue concerne des voitures thermiques datant d'avant 2006, sans véhicule électrique, hybride ni vans.
# Ainsi, la comparaison des véhicules du fichier CO2 et de notre catalogue n'est pas pertinente en termes de rejet CO2,etc..   


catalogue$categorie <- ifelse(catalogue$LONGUEUR == 'courte' | catalogue$LONGUEUR == 'moyenne' , 'citadine', 'routière')

catalogue$categorie[catalogue$PUISSANCE >= 350] <- 'sportive'

catalogue$categorie[catalogue$PRIX > 70000 & catalogue$PUISSANCE < 350] <- 'luxe'

catalogue$categorie[catalogue$NBPLACES > 5] <- 'familiale'

catalogue$categorie[catalogue$PRIX < 10000] <- 'low-cost'




#---------------------------------------------------------------------------------#
#  3. Application des catégories de véhicules définies au fichier immatriculations      
#---------------------------------------------------------------------------------#



# Création de la colonne catégorie dans le data frame "immatriculations"

immatriculations$categorie <- ifelse(immatriculations$LONGUEUR == 'courte' | immatriculations$LONGUEUR == 'moyenne' , 'citadine', 'routière')

immatriculations$categorie[immatriculations$PUISSANCE >= 350] <- 'sportive'

immatriculations$categorie[immatriculations$PRIX > 70000 & immatriculations$PUISSANCE < 350] <- 'luxe'

immatriculations$categorie[immatriculations$NBPLACES > 5] <- 'familiale'

immatriculations$categorie[immatriculations$PRIX < 10000] <- 'low-cost'


#------------------------------------------------------------------------------------------------#
#  4. Fusion des fichiers Clients.csv et Immatriculations.csv  --> création du dataframe "ventes"
#------------------------------------------------------------------------------------------------#


ventes <- inner_join(client, immatriculations, by= client$immatriculations)


#-----------------------------------------------------------------------------------------------------#
#  5. Création d'un modèle de classification supervisée pour la prédiction de la catégorie de véhicules
#-----------------------------------------------------------------------------------------------------#


#------------------------------------------------------------------------------------------------#
#          Détermination des variables à prendre en compte lors de l'apprentissage
#------------------------------------------------------------------------------------------------#


# On cherche à déterminer les variables sur les clients ayant une influence sur la catégorie de véhicule qui leur a été vendue.

# Visualisation age vs categorie
qplot(AGE, data=ventes, color=categorie)
qplot(AGE,categorie, data=ventes) + geom_jitter(height = 0.2, width = 0.2)
#  Toutes les voitures sportives ont été vendues à des personnes de 18 à 60 ans.
# Toutes les voitures de luxe ont été vendues à des personnes de plus de 60 ans.
# Les routières et les citadines se vendent de manière égale à tout age
# CCL : age est une variable importante.

# Visualisation sexe vs categorie
qplot(SEXE, data=ventes, color=categorie)
qplot(AGE, SEXE, data=ventes, color=categorie) + geom_jitter(height = 0.3, width = 0.3)
# La proportion de catégories vendues semble être identique pour les deux sexes
# CCL : sexe est une variable peu importante.

# Visualisation taux vs categorie
qplot(TAUX, data = ventes, color=categorie)
# La proportion de catégories vendues semble être identique pour toutes les valeurs de taux.
# On remarque qu'un taux faible booste les ventes cependant.
# CCL : taux est une variable peu importante.

# Visualisation situationFamiliale vs categorie
qplot(SITUATIONFAMILIALE, data = ventes, color=categorie)
# On observe que la proportion de catégories vendues diffère selon la situation familiale des clients.
# Plus de citadines sont vendues aux célibataires tandis que les personnes en couple préfèrent les routières ou les sportives.
# CCL : situationFamiliale est une variable importante.

# Visualisation nbEnfantsAcharge vs categorie
qplot(NBENFANTSACHARGE, data = ventes, color=categorie)
# On observe que la proportion de catégories vendues diffère selon le nombre d'enfants à charge des clients.
# Plus de citadines sont vendues aux clients ayant 0 enfant à charge, 
# plus routières sont vendues à ceux ayant entre 1 et 2 enfants à charge,
# Les clients ayant de 3 à 4 enfants à charge préfèrent les sportives.
# CCL : nbEnfantsAcharge est une variable importante.

# Visualisation X2eme.voiture vs categorie
qplot(DEUXIEMEVOITURE , data = ventes, color=categorie)
# On observe que la proportion de catégories vendues diffère selon si la voiture est une deuxième voiture.
# Quand X2eme.voiture est à false, les clients peuvent s'orienter sur des routières alors que quand X2eme.voiture
# est à true, la proportion de routières vendues est quasi nulle.
# CCL : X2eme.voiture est une variable importante.


# CCL : Les prédicteurs de nos modèles seront les variables : age, situationFamiliale, nbEnfantsAcharge, X2eme.voiture

# Note : on ne prend pas en compte les variables sur les véhicules (marque, puissance, nom, etc.) 
# car elles sont déjà synthétisées et prises en compte par la variable de classe : catégorie


#-----------------------------------------------------------#
#  Retrait des colonnes non pertinentes pour l'apprentissage
#-----------------------------------------------------------#


# On retire la colonne immatriculation de notre table car elle ne nous servira pas pour l'apprentissage
ventes <- subset(ventes, select = -IMMATRICULATION)

# On retire ensuite les colonnes que nous n'avons pas retenu lors de notre analyse précédente ainsi que les colonnes relatives aux spécifications des véhicules.
ventes <- subset(ventes, select = -SEXE)
ventes <- subset(ventes, select = -TAUX)
ventes <- subset(ventes, select = -MARQUE)
ventes <- subset(ventes, select = -NOM)
ventes <- subset(ventes, select = -PUISSANCE)
ventes <- subset(ventes, select = -LONGUEUR)
ventes <- subset(ventes, select = -NBPLACES)
ventes <- subset(ventes, select = -NBPORTES)
ventes <- subset(ventes, select = -COULEUR)
ventes <- subset(ventes, select = -OCCASION)
ventes <- subset(ventes, select = -PRIX)


# On construit l'ensemble d'apprentissage ventes_EA et l'ensemble de test ventes_ET
# comme suit (répartition 2/3 , 1/3):
# ventes_EA : sélection des 26318 premières lignes de produit.
# ventes_ET : sélection des 13158 dernières lignes de produit.

ventes_EA <- ventes[1:26318,]

ventes_ET <- ventes[26319:39476,]

# On passe les attributs de type char en facteur (necessaire pour implémenter le classifieur C50)

ventes_EA$categorie <- as.factor(ventes_EA$categorie)
ventes_EA$DEUXIEMEVOITURE <- as.factor(ventes_EA$DEUXIEMEVOITURE)
ventes_EA$SITUATIONFAMILIALE <- as.factor(ventes_EA$SITUATIONFAMILIALE)
#ventes_EA$sexe <- as.factor(ventes_EA$sexe)

ventes_ET$categorie <- as.factor(ventes_ET$categorie)
ventes_ET$DEUXIEMEVOITURE <- as.factor(ventes_ET$DEUXIEMEVOITURE)
ventes_ET$SITUATIONFAMILIALE <- as.factor(ventes_ET$SITUATIONFAMILIALE)
#ventes_ET$sexe <- as.factor(ventes_ET$sexe)



#-----------------------------------------------------------#
#  Evaluation des classifieurs de type : 
#  
# - Arbre de décision
# - Random Forest
# - Support Vector Machine
# - Naive Bayes
# - Neural Network
# - K nearest neighbours
#-----------------------------------------------------------#


#-----------------------------------------------------------#
#  Evaluation du classifieur : Arbre de décision
#-----------------------------------------------------------#

#----------------#
#  Paramétrage 1
#----------------#

# Apprentissage du classifeur de type arbre de décision
tree_C50_1 <- C5.0(categorie~., data = ventes_EA)

# Test du classifieur : classe prédite
result.tree_C50_1 <- predict(tree_C50_1, ventes_ET, type="class")

# Matrice de confusion (avec le package caret)
confusionMatrix(ventes_ET$categorie, result.tree_C50_1)

# Test du classifieur : probabilites pour chaque prediction
p.tree_C50_1 <- predict(tree_C50_1, ventes_ET, type="prob")

# Calcul de l'AUC
# D'aprés la documentation du package pROC, la fonction multiclass.roc() construit plusieurs courbes ROC 
# (une pour chaque couple de catégories possible. exemple : citadine/sportive ou encore routiére/citadine).
# Ensuite, elle calcule l'indice AUC multiclasse selon la définition de (Hand and Till, 2001)
# à partir des courbes ROC générées
auc.predTree_C50_1 <- multiclass.roc(ventes_ET$categorie,p.tree_C50_1)
print(auc.predTree_C50_1)

# Résultats : 

# Indice AUC : 0.9463

# Mesure de Rappel pour chaque classe (sensitivity) : 

# citadine : 0.9998
# luxe : 1
# routière : 0.7192
# sportive : 0.7932

# Mesure de Précision pour chaque classe (Pos pred value) : 

# citadine : 1
# luxe : 0.5920
# routière : 0.8970
# sportive : 0.5945

# Mesure de Classification Accuracy (globale) : 0.8498


#----------------#
#  Paramétrage 2
#----------------#

# On essaie d'appliquer le paramètre "rules = TRUE". On obtiendra, après l'exécution de la ligne suivante, 
# un set de règles au lieu d'un arbre de décision.

tree_C50_2 <- C5.0(categorie~., data = ventes_EA, rules = TRUE)
summary(tree_C50_2)

result.tree_C50_2 <- predict(tree_C50_2, ventes_ET, type="class")
confusionMatrix(ventes_ET$categorie, result.tree_C50_2)
p.tree_C50_2 <- predict(tree_C50_2, ventes_ET, type="prob")
auc.predTree_C50_2 <- multiclass.roc(ventes_ET$categorie,p.tree_C50_2)
print(auc.predTree_C50_2)

# Résultats : 

# Indice AUC : 0.8513


# Conclusion : Avec "rules = TRUE", l'indice AUC est moins bon.


#----------------#
#  Paramétrage 3
#----------------#

# On essaie d'appliquer le paramètre "trials = n" qui définit le nombre d'opérations
# de boosting lors de l'apprentissage (par défaut, trials = 1)

tree_C50_3 <- C5.0(categorie~., data = ventes_EA, trials = 10)

result.tree_C50_3 <- predict(tree_C50_3, ventes_ET, type="class")
confusionMatrix(ventes_ET$categorie, result.tree_C50_3)
p.tree_C50_3 <- predict(tree_C50_3, ventes_ET, type="prob")
auc.predTree_C50_3 <- multiclass.roc(ventes_ET$categorie,p.tree_C50_3)
print(auc.predTree_C50_3)

# Résultats : 

# Indice AUC : 0.9432

# Mesure de Rappel pour chaque classe (sensitivity) : 

# citadine : 0.9121
# luxe : 1.000
# routière : 0.7356
# sportive : 0.7941

# Mesure de Précision pour chaque classe (Pos pred value) : 

# citadine : 1
# luxe : 0.5920
# routière : 0.8915
# sportive : 0.4754

# Mesure de Classification Accuracy (globale) : 0.8219


# Conclusion : Tous les résultats sont moins bons que ceux obtenus avec le paramétrage par défaut (tree_c50_1).


#----------------#
#  Paramétrage 4
#----------------#

# On essaie de combiner les paramètres rules et trials 

tree_C50_4 <- C5.0(categorie~., data = ventes_EA, trials = 10, rules = TRUE)

result.tree_C50_4 <- predict(tree_C50_4, ventes_ET, type="class")
confusionMatrix(ventes_ET$categorie, result.tree_C50_4)
p.tree_C50_4 <- predict(tree_C50_4, ventes_ET, type="prob")
auc.predTree_C50_4 <- multiclass.roc(ventes_ET$categorie,p.tree_C50_4)
print(auc.predTree_C50_4)

# Résultats : 

# Indice AUC : 0.9447

# Mesure de Rappel pour chaque classe (sensitivity) : 

# citadine : 0.9998
# luxe : 0.9568
# routière : 0.7201
# sportive : 0.7932

# Mesure de Précision pour chaque classe (Pos pred value) : 

# citadine : 1
# luxe : 0.6103
# routière : 0.8915
# sportive : 0.5945

# Mesure de Classification Accuracy (globale) : 0.8492


# Conclusion : L'indice AUC est légèrement inférieur à celui obtenu avec le paramétrage 1 
# et les autres résultats sont sensiblement identiques à ceux obtenus avec le paramétrage 1.
# On peut alors retenir le paramétrage 1 (tree_c50_1) pour l'arbre de décision de type C50.


#-----------------------------------------------------------#
#  Evaluation du classifieur : Random Forest
#-----------------------------------------------------------#

#----------------#
#  Paramétrage 1
#----------------#

# Apprentissage du classifeur de type foret aleatoire 
rf_1 <- randomForest(categorie~., ventes_EA)

# Test du classifieur : classe prédite 
rf_class_1 <- predict(rf_1,ventes_ET, type="response")

# Matrice de confusion 
confusionMatrix(ventes_ET$categorie, rf_class_1)

# Test du classifieur : probabilites pour chaque prediction 
rf_prob_1 <- predict(rf_1, ventes_ET, type="prob")

# Conversion des probabilites en data frame 
rf_prob_1 <- as.data.frame(rf_prob_1)

# Calcul de l'AUC 
auc.rf_pred_1 <- multiclass.roc(ventes_ET$categorie, rf_prob_1)
print(auc.rf_pred_1)

# Résultats : 

# Indice AUC : 0.9021

# Moins bon que C50


#----------------#
#  Paramétrage 2
#----------------#

# On essaie de faire varier le nombre d'arbres dans la forêt (ntree), le nombre de noeuds maximal de noeuds feuilles de l'arbre
# (maxnodes) et l'effectif minimal des feuilles (nodesize). Par tâtonnement, la combinaison la plus optimale de ces trois
# paramètres semble être la suivante : 

rf_2 <- randomForest(categorie~., ventes_EA, maxnodes = 10, nodesize = 5, ntree = 600)

rf_class_2 <- predict(rf_2,ventes_ET, type="response")
confusionMatrix(ventes_ET$categorie, rf_class_2)
rf_prob_2 <- predict(rf_2, ventes_ET, type="prob")
rf_prob_2 <- as.data.frame(rf_prob_2)
auc.rf_pred_2 <- multiclass.roc(ventes_ET$categorie, rf_prob_2)
print(auc.rf_pred_2)

# Résultats : 

# Indice AUC : 0.9148

# Moins bon que C50


# Conclusion : l'indice AUC obtenu avec le paramétrage 2 est légèrement meilleur que celui obtenu 
# avec le paramétrage 1. Les autres résultats sont identiques donc on peut retenir le paramétrage 2
# pour la classification de type Random Forest. Cependant, les deux indices AUC obtenus sont inférieurs à ceux obtenus avec
# les classifieurs de type C50 donc on ne retiendra pas de classifieur de type Random Forest pour ce projet.


#-----------------------------------------------------------#
#  Evaluation du classifieur : Support Vector Machines
#-----------------------------------------------------------#


#----------------#
#  Paramétrage 1
#----------------#

# Apprentissage du classifeur de type svm
svm <- svm(categorie~., ventes_EA, probability=TRUE, cost=12)

# Test du classifieur : classe prédite
result.svm <- predict(svm, ventes_ET, type="response")

# Matrice de confus
confusionMatrix(ventes_ET$categorie, result.svm)

# Test du classifieur : probabilités pour chaque prédiction
svm_prob <- predict(svm, ventes_ET, probability=TRUE)

# Recuperation des probabilités associées aux prédictions
svm_prob <- attr(svm_prob, "probabilities")

# Conversion en un data frame  
svm_prob <- as.data.frame (svm_prob)

# Calcul de l'AUC 
auc.svm_pred <- multiclass.roc(ventes_ET$categorie, svm_prob)
print(auc.svm_pred)

# Résultats : 

# Indice AUC : 0.9473

# Mesure de Rappel pour chaque classe (sensitivity) : 

# citadine : 0.9998
# luxe : 1
# routière : 0.7192
# sportive : 0.7932

# Mesure de Précision pour chaque classe (Pos pred value) : 

# citadine : 1
# luxe : 0.5920
# routière : 0.8970
# sportive : 0.5945

# Mesure de Classification Accuracy (globale) : 0.8498

# Note : temps d'apprentissage très long 


#----------------#
#  Paramétrage 2
#----------------#


# Apprentissage du classifeur de type svm
svm <- svm(categorie~., ventes_EA, probability=TRUE, cost=18)

# Test du classifieur : classe prédite
result.svm <- predict(svm, ventes_ET, type="response")

# Matrice de confus
confusionMatrix(ventes_ET$categorie, result.svm)

# Test du classifieur : probabilités pour chaque prédiction
svm_prob <- predict(svm, ventes_ET, probability=TRUE)

# Recuperation des probabilités associées aux prédictions
svm_prob <- attr(svm_prob, "probabilities")

# Conversion en un data frame  
svm_prob <- as.data.frame (svm_prob)

# Calcul de l'AUC 
auc.svm_pred <- multiclass.roc(ventes_ET$categorie, svm_prob)
print(auc.svm_pred)

# Résultats : 

# Indice AUC : 0.9479

# Mesure de Rappel pour chaque classe (sensitivity) : 

# citadine : 0.9998
# luxe : 1
# routière : 0.7216
# sportive : 0.7957

# Mesure de Précision pour chaque classe (Pos pred value) : 

# citadine : 1
# luxe : 0.5906
# routière : 0.8961
# sportive : 0.6049

# Mesure de Classification Accuracy (globale) : 0.8513

# Note : temps d'apprentissage très long 

#-----------------------------------------------------------#
#  Evaluation du classifieur : Naive Bayes
#-----------------------------------------------------------#


#----------------#
#  Paramétrage 1
#----------------#

# Apprentissage du classifeur de type Naive Bayes
nb <- naive_bayes(categorie~., ventes_EA, laplace=12)

# Test du classifieur : classe prédite 
nb_class <- predict(nb,ventes_ET, type="class")

# Matrice de confusion 
confusionMatrix(ventes_ET$categorie, nb_class)

# Test du classifieur : probabilites pour chaque prediction 
nb_prob <- predict(nb, ventes_ET, type="prob")

# Calcul de l'AUC 
auc.nb_pred <- multiclass.roc(ventes_ET$categorie, nb_prob)
print(auc.nb_pred)

# Résultats : 

# Indice AUC : 0.9154

# Mesure de Rappel pour chaque classe (sensitivity) : 

# citadine : 0.8707
# luxe : 0.6778
# routière : 0.7125
# sportive : 0.6549

# Mesure de Précision pour chaque classe (Pos pred value) : 

# citadine : 0.8883
# luxe : 0.6789
# routière : 0.7457
# sportive : 0.5701

# Mesure de Classification Accuracy (globale) : 0.7571

#----------------#
#  Paramétrage 2
#----------------#


# Apprentissage du classifeur de type Naive Bayes
nb <- naive_bayes(categorie~., ventes_EA, laplace=30)

# Test du classifieur : classe prédite 
nb_class <- predict(nb,ventes_ET, type="class")

# Matrice de confusion 
confusionMatrix(ventes_ET$categorie, nb_class)

# Test du classifieur : probabilites pour chaque prediction 
nb_prob <- predict(nb, ventes_ET, type="prob")

# Calcul de l'AUC 
auc.nb_pred <- multiclass.roc(ventes_ET$categorie, nb_prob)
print(auc.nb_pred)

# Résultats : 

# Indice AUC : 0.9151

# Mesure de Rappel pour chaque classe (sensitivity) : 

# citadine : 0.8658
# luxe : 0.6277
# routière : 0.7126
# sportive : 0.6547

# Mesure de Précision pour chaque classe (Pos pred value) : 

# citadine : 0.8883
# luxe : 0.6789
# routière : 0.7409
# sportive : 0.5701

# Mesure de Classification Accuracy (globale) : 0.7555

#-----------------------------------------------------------#
#  Evaluation du classifieur : Neural Networks
#-----------------------------------------------------------#

#----------------#
#  Paramétrage 1
#----------------#

# Apprentissage du classifeur de type nn
nn <- nnet(categorie~., ventes_EA, size=12)

# Test du classifieur : classe predite
result.nn <- predict(nn, ventes_ET, type="class")

# On met les prédictions en facteur pour créer la matrice de confusion
result.nn <- as.factor(result.nn)

# Matrice de confusion
confusionMatrix(ventes_ET$categorie, result.nn)

# Test du classifieur : probabilites pour chaque prediction
nn_prob <- predict(nn, ventes_ET, type="raw")

# Calcul de l'AUC 
auc.nn_pred <- multiclass.roc(ventes_ET$categorie, nn_prob)
print(auc.nn_pred)

# Résultats : 

# Indice AUC : 0.9483

# Mesure de Rappel pour chaque classe (sensitivity) : 

# citadine : 0.9998
# luxe : 0.9981
# routière : 0.7215
# sportive : 0.7957

# Mesure de Précision pour chaque classe (Pos pred value) : 

# citadine : 1
# luxe : 0.5906
# routière : 0.8959
# sportive : 0.6049

# Mesure de Classification Accuracy (globale) : 0.7589  

#----------------#
#  Paramétrage 2
#----------------#


# Apprentissage du classifeur de type nn
nn <- nnet(categorie~., ventes_EA, size=18) 

# Test du classifieur : classe predite
result.nn <- predict(nn, ventes_ET, type="class")

# On met les prédictions en facteur pour créer la matrice de confusion
result.nn <- as.factor(result.nn)

# Matrice de confusion
confusionMatrix(ventes_ET$categorie, result.nn)

# Test du classifieur : probabilites pour chaque prediction
nn_prob <- predict(nn, ventes_ET, type="raw")

# Calcul de l'AUC 
auc.nn_pred <- multiclass.roc(ventes_ET$categorie, nn_prob)
print(auc.nn_pred)

# Résultats : 

# Indice AUC : 0.9492

# Mesure de Rappel pour chaque classe (sensitivity) : 

# citadine : 0.9998
# luxe : 0.99806
# routière : 0.7215
# sportive : 0.7957

# Mesure de Précision pour chaque classe (Pos pred value) : 

# citadine : 1
# luxe : 0.5906
# routière : 0.8959
# sportive : 0.6049

# Mesure de Classification Accuracy (globale) : 0.7807 


#-----------------------------------------------------------#
#  Evaluation du classifieur : k-nearest neighbors
#-----------------------------------------------------------#

#----------------#
#  Paramétrage 1
#----------------#


# Apprentissage et test simultanés du classifeur de type k-nearest neighbors 
kknn <- kknn(categorie~., ventes_EA, ventes_ET, k=12) 

# Matrice de confusion 
confusionMatrix(ventes_ET$categorie, kknn$fitted.values)

# Conversion des probabilités en data frame 
kknn_prob <- as.data.frame(kknn$prob)

# Calcul de l'AUC 
auc.kknn_pred <- multiclass.roc(ventes_ET$categorie, kknn_prob)
print(auc.kknn_pred)

# Résultats : 

# Indice AUC : 0.9374

# Mesure de Rappel pour chaque classe (sensitivity) : 

# citadine : 0.9998
# luxe : 0.8086
# routière : 0.7071
# sportive : 0.7279

# Mesure de Précision pour chaque classe (Pos pred value) : 

# citadine : 1
# luxe : 0.6640
# routière : 0.8207
# sportive : 0.5915

# Mesure de Classification Accuracy (globale) : 0.7489

#----------------#
#  Paramétrage 2
#----------------#


# Apprentissage et test simultanés du classifeur de type k-nearest neighbors 
kknn <- kknn(categorie~., ventes_EA, ventes_ET, k=256) 

# Matrice de confusion 
confusionMatrix(ventes_ET$categorie, kknn$fitted.values)

# Conversion des probabilités en data frame 
kknn_prob <- as.data.frame(kknn$prob)

# Calcul de l'AUC 
auc.kknn_pred <- multiclass.roc(ventes_ET$categorie, kknn_prob)
print(auc.kknn_pred)

# Résultats : 

# Indice AUC : 0.9443

# Mesure de Rappel pour chaque classe (sensitivity) : 

# citadine : 0.9972
# luxe : 0.9980
# routière : 0.7220
# sportive : 0.7928

# Mesure de Précision pour chaque classe (Pos pred value) : 

# citadine : 1
# luxe : 0.5814
# routière : 0.8943
# sportive : 0.6049

# Mesure de Classification Accuracy (globale) : 0.8501 




#------------------------------------------------------------------#
#  6. Application du modèle de prédiction au fichier Marketing.csv
#------------------------------------------------------------------#


# Modèle de prédiction choisi : tree_c50_4


# Classes prédites
predictions_marketing <- predict(tree_C50_4, marketing, type="class")
table(predictions_marketing)

# Probabilités pour chaque classe prédite
probabilites_marketing <- predict(tree_C50_4, marketing, type="prob")
probabilites_marketing

# Création d'un nouveau data frame avec les résultats
resultats_marketing <- data.frame(marketing, predictions_marketing, probabilites_marketing)

# Exportation des résultats dans un fichier csv
write.table(
  resultats_marketing, 
  file = "resultats_marketing.csv", 
  sep = ";", 
  dec = ".",
  row.names = F)

