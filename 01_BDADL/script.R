#-----------------------------------------------------#
#                     Groupe 1 
#
#   MOMAS Lisa, FOURNIER Alphonse, TAMANINI Nicolas   
#-----------------------------------------------------#


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

# Chargement des données CATALOGUE

catalogue <- read.csv(
  "Catalogue.csv", 
  header = TRUE, 
  sep = ",", 
  dec = "."
)

# Chargement des données IMMATRICULATIONS

immatriculations <- read.csv(
  "Immatriculations.csv", 
  header = TRUE, 
  sep = ",", 
  dec = "."
)

# Chargement des données MARKETING

marketing <- read.csv(
  "Marketing.csv", 
  header = TRUE, 
  sep = ",", 
  dec = "."
)

# Chargement des données CLIENTS_0

client <- read.csv("Clients_0.csv", header = TRUE, sep = ",", dec = ".")


#--------------------------------------#
#  1. Analyse exploratoire des données      
#--------------------------------------#


#--------------------------------------#
#             CATALOGUE.CSV
#--------------------------------------#

# Test pour identifier la présence de doublons

sum(duplicated(catalogue))

# pas de lignes dupliquées 


# Exploration visuelle du tableau de valeurs --> Pas de valeurs manquantes


# Vérification des contraintes de domaine 

# Marque : Affichage des effectifs de la variable marque : 

table(catalogue$marque)

# Pas de marque inconnue


# Nom du véhicule : Affichage des effectifs de la variable nom : 

table(catalogue$nom)

# Pas de nom inconnu


# Puissance : affichage des statistiques élémentaires de la variable puissance

summary(catalogue$puissance)

# Les puissances sont bien dans l'intervalle [55,507]


# Longueur : Affichage des effectifs de la variable longueur : 

table(catalogue$longueur)

# Pas de catégorie de longueur inconnue


# Nombre de places : histogramme des effectifs de la variable nbPlaces

qplot(nbPlaces, data=catalogue, bins=3)

# Bien dans l'intervalle [5,7]



# Nombre de portes : histogramme des effectifs de la variable nbPortes

qplot(nbPortes, data=catalogue, bins=3)

# Bien dans l'intervalle [3,5]



# Couleur :  Affichage des effectifs de la variable couleur

table(catalogue$couleur)

# Pas de couleur inconnue



# Occasion :  Affichage des effectifs de la variable occasion

table(catalogue$occasion)

# On a bien que des booléens



# Prix : affichage des statistiques élémentaires de la variable prix

summary(catalogue$prix)

# Prix bien dans l'intervalle [7500,101300]


#--------------------------------------#
#         IMMATRICULATIONS.CSV
#--------------------------------------#


# Test pour identifier la présence de doublons

sum(duplicated(immatriculations))

# suppression des lignes dupliquées à l'aide de la librairie dplyr

immatriculations <- distinct(immatriculations)




# Vérification des contraintes de domaine 


# immatriculation

# Test pour identifier la présence de doublons au sein des numéros d'immatriculations

sum(duplicated(immatriculations$immatriculation))

# suppression des lignes dupliquées à l'aide de la librairie dplyr

immatriculations <- distinct(immatriculations, immatriculation, .keep_all = TRUE)


# Format du numéro d'immatriculation

# On souhaite le format Â« 9999 AA 99 Â» qui comprend 10 caractères
# On supprime donc les lignes dont le numéro d'immatriculation est inférieur à 10 caractères

immatriculations <- immatriculations[str_count(immatriculations$immatriculation) == 10,]


# Marque : Affichage des effectifs de la variable marque : 

table(immatriculations$marque)

# Pas de marque inconnue


# Nom du véhicule : Affichage des effectifs de la variable nom : 

table(immatriculations$nom)

# Pas de nom inconnu



# Puissance : affichage des statistiques élémentaires de la variable puissance

summary(immatriculations$puissance)

# Les puissances sont bien dans l'intervalle [55,507]


# Longueur : Affichage des effectifs de la variable longueur : 

table(immatriculations$longueur)

# Pas de catégorie de longueur inconnue


# Nombre de places : histogramme des effectifs de la variable nbPlaces

table(immatriculations$nbPlaces)

# Bien dans l'intervalle [5,7]



# Nombre de portes : histogramme des effectifs de la variable nbPortes

qplot(nbPortes, data=immatriculations, bins=3)

# Bien dans l'intervalle [3,5]



# Couleur :  Affichage des effectifs de la variable couleur

table(immatriculations$couleur)

# Pas de couleur inconnue



# Occasion :  Affichage des effectifs de la variable occasion

table(immatriculations$occasion)

# On a bien que des booléens



# Prix : affichage des statistiques élémentaires de la variable prix

summary(immatriculations$prix)

# Prix bien dans l'intervalle [7500,101300]


#--------------------------------------#
#            CLIENTS_0.CSV
#--------------------------------------#


#visualisation de données
summary(client)
View(client)
qplot(nbEnfantsAcharge, data=client)

#    TRI AGE 
# Accepter que les valeurs comprises entre 18 et 84.
client <- client%>% filter(client$age %in% (18:84))
client$age <- as.numeric(client$age)

# TRI TAUX
# Accepter les valeurs comprises entre 544 et 74 185.
client <- client%>% filter(client$taux %in% (544:74185))
client$taux <- as.numeric(client$taux)

# TRI NBENFANTSACHARGE
# Accepte que les valeurs comprises entre 0 et 4
client <- client%>% filter(client$nbEnfantsAcharge %in% (0:4))
client$nbEnfantsAcharge <- as.numeric(client$nbEnfantsAcharge)
qplot(nbEnfantsAcharge, data=client)

#    TRI SEXE
# Remplacer les valeurs mal saisies au format F pour Femme et M pour Masculin
client$sexe <- ifelse(client$sexe=="Masculin", "M", client$sexe)
client$sexe <- ifelse(client$sexe=="Homme", "M", client$sexe)
client$sexe <- ifelse(client$sexe=="Féminin", "F", client$sexe)
client$sexe <- ifelse(client$sexe=="Femme", "F", client$sexe)

# Suppression des autres valeurs de sexe (autres que F et M)
client <- subset(client, client$sexe == "F" | client$sexe == "M" )

#   TRI SITUATION FAMILIALE
# Mise en forme de la catégoie en: "En couple", "Célibataire", "Divorcée"
client$situationFamiliale <- ifelse(client$situationFamiliale=="Seule", "Célibataire", client$situationFamiliale)
client$situationFamiliale <- ifelse(client$situationFamiliale=="Seul", "Célibataire", client$situationFamiliale)

# Suppression des autres valeurs non listé dans la catégorie
client <- subset(client, client$situationFamiliale == "Célibataire" | client$situationFamiliale == "Divorcée" | situationFamiliale == "En Couple")

# TRI X2EME.VOITURE
#Accepte que les valeurs égale à "tru" ou "false"
client <- subset(client, client$X2eme.voiture  == "true" | client$X2eme.voiture  == "false")

# TRI IMMATRICULATION
# Garder que les plaques d'immatriculations de 10 charactères
client <- client[str_count(client$immatriculation) == 10,]

# Test pour identifier la présence de doublons
sum(duplicated(client$immatriculation))

# suppression des lignes dupliquées à l'aide de la librairie dplyr
client <- distinct(client, immatriculation, .keep_all = TRUE)




#-----------------------------------------------#
#  2. Identification des catégories de véhicules      
#-----------------------------------------------#


# Création de la colonne catégorie dans le data frame "catalogue"

catalogue$categorie <- ifelse(catalogue$longueur == 'courte' | catalogue$longueur == 'moyenne' , 'citadine', 'routière')

catalogue$categorie[catalogue$puissance >= 350] <- 'sportive'

catalogue$categorie[catalogue$prix > 70000 & catalogue$puissance < 350] <- 'luxe'

catalogue$categorie[catalogue$nbPlaces > 5] <- 'familiale'

catalogue$categorie[catalogue$prix < 10000] <- 'low-cost'




#---------------------------------------------------------------------------------#
#  3. Application des catégories de véhicules définies au fichier immatriculations      
#---------------------------------------------------------------------------------#



# Création de la colonne catégorie dans le data frame "immatriculations"

immatriculations$categorie <- ifelse(immatriculations$longueur == 'courte' | immatriculations$longueur == 'moyenne' , 'citadine', 'routière')

immatriculations$categorie[immatriculations$puissance >= 350] <- 'sportive'

immatriculations$categorie[immatriculations$prix > 70000 & immatriculations$puissance < 350] <- 'luxe'

immatriculations$categorie[immatriculations$nbPlaces > 5] <- 'familiale'

immatriculations$categorie[immatriculations$prix < 10000] <- 'low-cost'


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
qplot(age, data=ventes, color=categorie)
qplot(age,categorie, data=ventes) + geom_jitter(height = 0.2, width = 0.2)
#  Toutes les voitures sportives ont été vendues à des personnes de 18 à 60 ans.
# Toutes les voitures de luxe ont été vendues à des personnes de plus de 60 ans.
# Les routières et les citadines se vendent de manière égale à tout age
# CCL : age est une variable importante.

# Visualisation sexe vs categorie
qplot(sexe, data=ventes, color=categorie)
qplot(age, sexe, data=ventes, color=categorie) + geom_jitter(height = 0.3, width = 0.3)
# La proportion de catégories vendues semble être identique pour les deux sexes
# CCL : sexe est une variable peu importante.

# Visualisation taux vs categorie
qplot(taux, data = ventes, color=categorie)
# La proportion de catégories vendues semble être identique pour toutes les valeurs de taux.
# On remarque qu'un taux faible booste les ventes cependant.
# CCL : taux est une variable peu importante.

# Visualisation situationFamiliale vs categorie
qplot(situationFamiliale, data = ventes, color=categorie)
# On observe que la proportion de catégories vendues diffère selon la situation familiale des clients.
# Plus de citadines sont vendues aux célibataires tandis que les personnes en couple préfèrent les routières ou les sportives.
# CCL : situationFamiliale est une variable importante.

# Visualisation nbEnfantsAcharge vs categorie
qplot(nbEnfantsAcharge, data = ventes, color=categorie)
# On observe que la proportion de catégories vendues diffère selon le nombre d'enfants à charge des clients.
# Plus de citadines sont vendues aux clients ayant 0 enfant à charge, 
# plus routières sont vendues à ceux ayant entre 1 et 2 enfants à charge,
# Les clients ayant de 3 à 4 enfants à charge préfèrent les sportives.
# CCL : nbEnfantsAcharge est une variable importante.

# Visualisation X2eme.voiture vs categorie
qplot(X2eme.voiture , data = ventes, color=categorie)
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
ventes <- subset(ventes, select = -immatriculation)

# On retire ensuite les colonnes que nous n'avons pas retenu lors de notre analyse précédente.
ventes <- subset(ventes, select = -sexe)
ventes <- subset(ventes, select = -taux)
ventes <- subset(ventes, select = -marque)
ventes <- subset(ventes, select = -nom)
ventes <- subset(ventes, select = -puissance)
ventes <- subset(ventes, select = -longueur)
ventes <- subset(ventes, select = -nbPlaces)
ventes <- subset(ventes, select = -nbPortes)
ventes <- subset(ventes, select = -couleur)
ventes <- subset(ventes, select = -occasion)
ventes <- subset(ventes, select = -prix)


# On construit l'ensemble d'apprentissage ventes_EA et l'ensemble de test ventes_ET
# comme suit (répartition 2/3 , 1/3):
# ventes_EA : sélection des 26318 premières lignes de produit.
# ventes_ET : sélection des 13158 dernières lignes de produit.

ventes_EA <- ventes[1:26318,]

ventes_ET <- ventes[26319:39476,]

# On passe les attributs de type char en facteur (necessaire pour implémenter le classifieur C50)

ventes_EA$categorie <- as.factor(ventes_EA$categorie)
ventes_EA$X2eme.voiture <- as.factor(ventes_EA$X2eme.voiture)
ventes_EA$situationFamiliale <- as.factor(ventes_EA$situationFamiliale)
#ventes_EA$sexe <- as.factor(ventes_EA$sexe)

ventes_ET$categorie <- as.factor(ventes_ET$categorie)
ventes_ET$X2eme.voiture <- as.factor(ventes_ET$X2eme.voiture)
ventes_ET$situationFamiliale <- as.factor(ventes_ET$situationFamiliale)
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
# é partir des courbes ROC générées
auc.predTree_C50_1 <- multiclass.roc(ventes_ET$categorie,p.tree_C50_1)
print(auc.predTree_C50_1)

# Résultats : 

  # Indice AUC : 0.9467

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
  
  # Mesure de Classification Accuracy (globale) : 0.8513

  
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

  # Indice AUC : 0.8526


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

  # Indice AUC : 0.9372
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
  
    # citadine : 0.9121
    # luxe : 0.5763
    # routière : 0.7356
    # sportive : 0.7941
  
  # Mesure de Précision pour chaque classe (Pos pred value) : 
  
    # citadine : 1
    # luxe : 0.9484
    # routière : 0.7503
    # sportive : 0.4836
  
  # Mesure de Classification Accuracy (globale) : 0.8001


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

  # Indice AUC : 0.9473
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
  
    # citadine : 0.9998
    # luxe : 0.9519
    # routière : 0.7227
    # sportive : 0.7957
  
  # Mesure de Précision pour chaque classe (Pos pred value) : 
    
    # citadine : 1
    # luxe : 0.6124
    # routière : 0.8899
    # sportive : 0.6049
  
  # Mesure de Classification Accuracy (globale) : 0.8507


# Conclusion : L'indice AUC est légèrement supérieur à celui obtenu avec le paramétrage 1 
# et les autres résultats sont sensiblement identiques à ceux obtenus avec le paramétrage 1.
# On peut alors retenir le paramétrage 4 (tree_c50_4) pour l'arbre de décision de type C50.


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

  # Indice AUC : 0.9106
  
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
  
  # Mesure de Classification Accuracy (globale) : 0.8513


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

  # Indice AUC : 0.9162
  
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
  
  # Mesure de Classification Accuracy (globale) : 0.8513


# Conclusion : l'indice AUC obtenu avec le paramétrage 2 est légèrement meilleur que celui obtenu 
# avec le paramétrage 1. Les autres résultats sont identiques donc on peut retenir le paramétrage 2
# pour la classification de type Random Forest.


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

  # Indice AUC : 0.9475
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
  
    # citadine : 0.9998
    # luxe : 1
    # routière : 0.7217
    # sportive : 0.7957
  
  # Mesure de Précision pour chaque classe (Pos pred value) : 
  
    # citadine : 1
    # luxe : 0.5906
    # routière : 0.8961
    # sportive : 0.6049
  
  # Mesure de Classification Accuracy (globale) : 0.8513

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

