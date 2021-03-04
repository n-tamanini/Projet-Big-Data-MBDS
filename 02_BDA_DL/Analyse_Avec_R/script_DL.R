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

# Chargement des donn�es CATALOGUE

catalogue <- read.csv(
  "Catalogue.csv", 
  header = TRUE, 
  sep = ",", 
  dec = "."
)

# Chargement des donn�es IMMATRICULATIONS

immatriculations <- read.csv(
  "Immatriculations.csv", 
  header = TRUE, 
  sep = ",", 
  dec = "."
)

# Chargement des donn�es MARKETING

marketing <- read.csv(
  "Marketing.csv", 
  header = TRUE, 
  sep = ",", 
  dec = "."
)

# Chargement des donn�es CLIENTS_0

client <- read.csv("Clients_0.csv", header = TRUE, sep = ",", dec = ".")


#--------------------------------------#
#  1. Analyse exploratoire des donn�es      
#--------------------------------------#


#--------------------------------------#
#             CATALOGUE.CSV
#--------------------------------------#

# Test pour identifier la pr�sence de doublons

sum(duplicated(catalogue))

# pas de lignes dupliqu�es 


# Exploration visuelle du tableau de valeurs --> Pas de valeurs manquantes


# V�rification des contraintes de domaine 

# Marque : Affichage des effectifs de la variable marque : 

table(catalogue$marque)

# Pas de marque inconnue


# Nom du v�hicule : Affichage des effectifs de la variable nom : 

table(catalogue$nom)

# Pas de nom inconnu


# Puissance : affichage des statistiques �l�mentaires de la variable puissance

summary(catalogue$puissance)

# Les puissances sont bien dans l'intervalle [55,507]


# Longueur : Affichage des effectifs de la variable longueur : 

table(catalogue$longueur)

# Pas de cat�gorie de longueur inconnue


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

# On a bien que des bool�ens



# Prix : affichage des statistiques �l�mentaires de la variable prix

summary(catalogue$prix)

# Prix bien dans l'intervalle [7500,101300]


#--------------------------------------#
#         IMMATRICULATIONS.CSV
#--------------------------------------#


# Test pour identifier la pr�sence de doublons

sum(duplicated(immatriculations))

# suppression des lignes dupliqu�es � l'aide de la librairie dplyr

immatriculations <- distinct(immatriculations)




# V�rification des contraintes de domaine 


# immatriculation

# Test pour identifier la pr�sence de doublons au sein des num�ros d'immatriculations

sum(duplicated(immatriculations$immatriculation))

# suppression des lignes dupliqu�es � l'aide de la librairie dplyr

immatriculations <- distinct(immatriculations, immatriculation, .keep_all = TRUE)


# Format du num�ro d'immatriculation

# On souhaite le format « 9999 AA 99 » qui comprend 10 caract�res
# On supprime donc les lignes dont le num�ro d'immatriculation est inf�rieur � 10 caract�res

immatriculations <- immatriculations[str_count(immatriculations$immatriculation) == 10,]


# Marque : Affichage des effectifs de la variable marque : 

table(immatriculations$marque)

# Pas de marque inconnue


# Nom du v�hicule : Affichage des effectifs de la variable nom : 

table(immatriculations$nom)

# Pas de nom inconnu



# Puissance : affichage des statistiques �l�mentaires de la variable puissance

summary(immatriculations$puissance)

# Les puissances sont bien dans l'intervalle [55,507]


# Longueur : Affichage des effectifs de la variable longueur : 

table(immatriculations$longueur)

# Pas de cat�gorie de longueur inconnue


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

# On a bien que des bool�ens



# Prix : affichage des statistiques �l�mentaires de la variable prix

summary(immatriculations$prix)

# Prix bien dans l'intervalle [7500,101300]


#--------------------------------------#
#            CLIENTS_0.CSV
#--------------------------------------#


#visualisation de donn�es
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
client$sexe <- ifelse(client$sexe=="F�minin", "F", client$sexe)
client$sexe <- ifelse(client$sexe=="Femme", "F", client$sexe)

# Suppression des autres valeurs de sexe (autres que F et M)
client <- subset(client, client$sexe == "F" | client$sexe == "M" )

#   TRI SITUATION FAMILIALE
# Mise en forme de la cat�goie en: "En couple", "C�libataire", "Divorc�e"
client$situationFamiliale <- ifelse(client$situationFamiliale=="Seule", "C�libataire", client$situationFamiliale)
client$situationFamiliale <- ifelse(client$situationFamiliale=="Seul", "C�libataire", client$situationFamiliale)

# Suppression des autres valeurs non list� dans la cat�gorie
client <- subset(client, client$situationFamiliale == "C�libataire" | client$situationFamiliale == "Divorc�e" | situationFamiliale == "En Couple")

# TRI X2EME.VOITURE
#Accepte que les valeurs �gale � "tru" ou "false"
client <- subset(client, client$X2eme.voiture  == "true" | client$X2eme.voiture  == "false")

# TRI IMMATRICULATION
# Garder que les plaques d'immatriculations de 10 charact�res
client <- client[str_count(client$immatriculation) == 10,]

# Test pour identifier la pr�sence de doublons
sum(duplicated(client$immatriculation))

# suppression des lignes dupliqu�es � l'aide de la librairie dplyr
client <- distinct(client, immatriculation, .keep_all = TRUE)




#-----------------------------------------------#
#  2. Identification des cat�gories de v�hicules      
#-----------------------------------------------#


# Cr�ation de la colonne cat�gorie dans le data frame "catalogue"

catalogue$categorie <- ifelse(catalogue$longueur == 'courte' | catalogue$longueur == 'moyenne' , 'citadine', 'routi�re')

catalogue$categorie[catalogue$puissance >= 350] <- 'sportive'

catalogue$categorie[catalogue$prix > 70000 & catalogue$puissance < 350] <- 'luxe'

catalogue$categorie[catalogue$nbPlaces > 5] <- 'familiale'

catalogue$categorie[catalogue$prix < 10000] <- 'low-cost'




#---------------------------------------------------------------------------------#
#  3. Application des cat�gories de v�hicules d�finies au fichier immatriculations      
#---------------------------------------------------------------------------------#



# Cr�ation de la colonne cat�gorie dans le data frame "immatriculations"

immatriculations$categorie <- ifelse(immatriculations$longueur == 'courte' | immatriculations$longueur == 'moyenne' , 'citadine', 'routi�re')

immatriculations$categorie[immatriculations$puissance >= 350] <- 'sportive'

immatriculations$categorie[immatriculations$prix > 70000 & immatriculations$puissance < 350] <- 'luxe'

immatriculations$categorie[immatriculations$nbPlaces > 5] <- 'familiale'

immatriculations$categorie[immatriculations$prix < 10000] <- 'low-cost'


#------------------------------------------------------------------------------------------------#
#  4. Fusion des fichiers Clients.csv et Immatriculations.csv  --> cr�ation du dataframe "ventes"
#------------------------------------------------------------------------------------------------#


ventes <- inner_join(client, immatriculations, by= client$immatriculations)


#-----------------------------------------------------------------------------------------------------#
#  5. Cr�ation d'un mod�le de classification supervis�e pour la pr�diction de la cat�gorie de v�hicules
#-----------------------------------------------------------------------------------------------------#


#------------------------------------------------------------------------------------------------#
#          D�termination des variables � prendre en compte lors de l'apprentissage
#------------------------------------------------------------------------------------------------#


# On cherche � d�terminer les variables sur les clients ayant une influence sur la cat�gorie de v�hicule qui leur a �t� vendue.

# Visualisation age vs categorie
qplot(age, data=ventes, color=categorie)
qplot(age,categorie, data=ventes) + geom_jitter(height = 0.2, width = 0.2)
#  Toutes les voitures sportives ont �t� vendues � des personnes de 18 � 60 ans.
# Toutes les voitures de luxe ont �t� vendues � des personnes de plus de 60 ans.
# Les routi�res et les citadines se vendent de mani�re �gale � tout age
# CCL : age est une variable importante.

# Visualisation sexe vs categorie
qplot(sexe, data=ventes, color=categorie)
qplot(age, sexe, data=ventes, color=categorie) + geom_jitter(height = 0.3, width = 0.3)
# La proportion de cat�gories vendues semble �tre identique pour les deux sexes
# CCL : sexe est une variable peu importante.

# Visualisation taux vs categorie
qplot(taux, data = ventes, color=categorie)
# La proportion de cat�gories vendues semble �tre identique pour toutes les valeurs de taux.
# On remarque qu'un taux faible booste les ventes cependant.
# CCL : taux est une variable peu importante.

# Visualisation situationFamiliale vs categorie
qplot(situationFamiliale, data = ventes, color=categorie)
# On observe que la proportion de cat�gories vendues diff�re selon la situation familiale des clients.
# Plus de citadines sont vendues aux c�libataires tandis que les personnes en couple pr�f�rent les routi�res ou les sportives.
# CCL : situationFamiliale est une variable importante.

# Visualisation nbEnfantsAcharge vs categorie
qplot(nbEnfantsAcharge, data = ventes, color=categorie)
# On observe que la proportion de cat�gories vendues diff�re selon le nombre d'enfants � charge des clients.
# Plus de citadines sont vendues aux clients ayant 0 enfant � charge, 
# plus routi�res sont vendues � ceux ayant entre 1 et 2 enfants � charge,
# Les clients ayant de 3 � 4 enfants � charge pr�f�rent les sportives.
# CCL : nbEnfantsAcharge est une variable importante.

# Visualisation X2eme.voiture vs categorie
qplot(X2eme.voiture , data = ventes, color=categorie)
# On observe que la proportion de cat�gories vendues diff�re selon si la voiture est une deuxi�me voiture.
# Quand X2eme.voiture est � false, les clients peuvent s'orienter sur des routi�res alors que quand X2eme.voiture
# est � true, la proportion de routi�res vendues est quasi nulle.
# CCL : X2eme.voiture est une variable importante.


# CCL : Les pr�dicteurs de nos mod�les seront les variables : age, situationFamiliale, nbEnfantsAcharge, X2eme.voiture

# Note : on ne prend pas en compte les variables sur les v�hicules (marque, puissance, nom, etc.) 
# car elles sont d�j� synth�tis�es et prises en compte par la variable de classe : cat�gorie


#-----------------------------------------------------------#
#  Retrait des colonnes non pertinentes pour l'apprentissage
#-----------------------------------------------------------#


# On retire la colonne immatriculation de notre table car elle ne nous servira pas pour l'apprentissage
ventes <- subset(ventes, select = -immatriculation)

# On retire ensuite les colonnes que nous n'avons pas retenu lors de notre analyse pr�c�dente.
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
# comme suit (r�partition 2/3 , 1/3):
# ventes_EA : s�lection des 26318 premi�res lignes de produit.
# ventes_ET : s�lection des 13158 derni�res lignes de produit.

ventes_EA <- ventes[1:26318,]

ventes_ET <- ventes[26319:39476,]

# On passe les attributs de type char en facteur (necessaire pour impl�menter le classifieur C50)

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
# - Arbre de d�cision
# - Random Forest
# - Support Vector Machine
# - Naive Bayes
# - Neural Network
# - K nearest neighbours
#-----------------------------------------------------------#


#-----------------------------------------------------------#
#  Evaluation du classifieur : Arbre de d�cision
#-----------------------------------------------------------#

    #----------------#
    #  Param�trage 1
    #----------------#

# Apprentissage du classifeur de type arbre de d�cision
tree_C50_1 <- C5.0(categorie~., data = ventes_EA)

# Test du classifieur : classe pr�dite
result.tree_C50_1 <- predict(tree_C50_1, ventes_ET, type="class")

# Matrice de confusion (avec le package caret)
confusionMatrix(ventes_ET$categorie, result.tree_C50_1)

# Test du classifieur : probabilites pour chaque prediction
p.tree_C50_1 <- predict(tree_C50_1, ventes_ET, type="prob")

# Calcul de l'AUC
# D'apr�s la documentation du package pROC, la fonction multiclass.roc() construit plusieurs courbes ROC 
# (une pour chaque couple de cat�gories possible. exemple : citadine/sportive ou encore routi�re/citadine).
# Ensuite, elle calcule l'indice AUC multiclasse selon la d�finition de (Hand and Till, 2001)
# � partir des courbes ROC g�n�r�es
auc.predTree_C50_1 <- multiclass.roc(ventes_ET$categorie,p.tree_C50_1)
print(auc.predTree_C50_1)

# R�sultats : 

  # Indice AUC : 0.9467

  # Mesure de Rappel pour chaque classe (sensitivity) : 
    
    # citadine : 0.9998
    # luxe : 0.9981
    # routi�re : 0.7215
    # sportive : 0.7957
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 
    
    # citadine : 1
    # luxe : 0.5906
    # routi�re : 0.8959
    # sportive : 0.6049
  
  # Mesure de Classification Accuracy (globale) : 0.8513

  
    #----------------#
    #  Param�trage 2
    #----------------#

# On essaie d'appliquer le param�tre "rules = TRUE". On obtiendra, apr�s l'ex�cution de la ligne suivante, 
# un set de r�gles au lieu d'un arbre de d�cision.

tree_C50_2 <- C5.0(categorie~., data = ventes_EA, rules = TRUE)
summary(tree_C50_2)
  
result.tree_C50_2 <- predict(tree_C50_2, ventes_ET, type="class")
confusionMatrix(ventes_ET$categorie, result.tree_C50_2)
p.tree_C50_2 <- predict(tree_C50_2, ventes_ET, type="prob")
auc.predTree_C50_2 <- multiclass.roc(ventes_ET$categorie,p.tree_C50_2)
print(auc.predTree_C50_2)

# R�sultats : 

  # Indice AUC : 0.8526


# Conclusion : Avec "rules = TRUE", l'indice AUC est moins bon.
  

    #----------------#
    #  Param�trage 3
    #----------------#

# On essaie d'appliquer le param�tre "trials = n" qui d�finit le nombre d'op�rations
# de boosting lors de l'apprentissage (par d�faut, trials = 1)

tree_C50_3 <- C5.0(categorie~., data = ventes_EA, trials = 10)

result.tree_C50_3 <- predict(tree_C50_3, ventes_ET, type="class")
confusionMatrix(ventes_ET$categorie, result.tree_C50_3)
p.tree_C50_3 <- predict(tree_C50_3, ventes_ET, type="prob")
auc.predTree_C50_3 <- multiclass.roc(ventes_ET$categorie,p.tree_C50_3)
print(auc.predTree_C50_3)

# R�sultats : 

  # Indice AUC : 0.9372
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
  
    # citadine : 0.9121
    # luxe : 0.5763
    # routi�re : 0.7356
    # sportive : 0.7941
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 
  
    # citadine : 1
    # luxe : 0.9484
    # routi�re : 0.7503
    # sportive : 0.4836
  
  # Mesure de Classification Accuracy (globale) : 0.8001


# Conclusion : Tous les r�sultats sont moins bons que ceux obtenus avec le param�trage par d�faut (tree_c50_1).


    #----------------#
    #  Param�trage 4
    #----------------#

# On essaie de combiner les param�tres rules et trials 

tree_C50_4 <- C5.0(categorie~., data = ventes_EA, trials = 10, rules = TRUE)

result.tree_C50_4 <- predict(tree_C50_4, ventes_ET, type="class")
confusionMatrix(ventes_ET$categorie, result.tree_C50_4)
p.tree_C50_4 <- predict(tree_C50_4, ventes_ET, type="prob")
auc.predTree_C50_4 <- multiclass.roc(ventes_ET$categorie,p.tree_C50_4)
print(auc.predTree_C50_4)

# R�sultats : 

  # Indice AUC : 0.9473
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
  
    # citadine : 0.9998
    # luxe : 0.9519
    # routi�re : 0.7227
    # sportive : 0.7957
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 
    
    # citadine : 1
    # luxe : 0.6124
    # routi�re : 0.8899
    # sportive : 0.6049
  
  # Mesure de Classification Accuracy (globale) : 0.8507


# Conclusion : L'indice AUC est l�g�rement sup�rieur � celui obtenu avec le param�trage 1 
# et les autres r�sultats sont sensiblement identiques � ceux obtenus avec le param�trage 1.
# On peut alors retenir le param�trage 4 (tree_c50_4) pour l'arbre de d�cision de type C50.


#-----------------------------------------------------------#
#  Evaluation du classifieur : Random Forest
#-----------------------------------------------------------#

    #----------------#
    #  Param�trage 1
    #----------------#

# Apprentissage du classifeur de type foret aleatoire 
rf_1 <- randomForest(categorie~., ventes_EA)

# Test du classifieur : classe pr�dite 
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

# R�sultats : 

  # Indice AUC : 0.9106
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
    
    # citadine : 0.9998
    # luxe : 0.9981
    # routi�re : 0.7215
    # sportive : 0.7957
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 
  
    # citadine : 1
    # luxe : 0.5906
    # routi�re : 0.8959
    # sportive : 0.6049
  
  # Mesure de Classification Accuracy (globale) : 0.8513


    #----------------#
    #  Param�trage 2
    #----------------#

# On essaie de faire varier le nombre d'arbres dans la for�t (ntree), le nombre de noeuds maximal de noeuds feuilles de l'arbre
# (maxnodes) et l'effectif minimal des feuilles (nodesize). Par t�tonnement, la combinaison la plus optimale de ces trois
# param�tres semble �tre la suivante : 

rf_2 <- randomForest(categorie~., ventes_EA, maxnodes = 10, nodesize = 5, ntree = 600)

rf_class_2 <- predict(rf_2,ventes_ET, type="response")
confusionMatrix(ventes_ET$categorie, rf_class_2)
rf_prob_2 <- predict(rf_2, ventes_ET, type="prob")
rf_prob_2 <- as.data.frame(rf_prob_2)
auc.rf_pred_2 <- multiclass.roc(ventes_ET$categorie, rf_prob_2)
print(auc.rf_pred_2)

# R�sultats : 

  # Indice AUC : 0.9162
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
  
    # citadine : 0.9998
    # luxe : 0.9981
    # routi�re : 0.7215
    # sportive : 0.7957
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 
    
    # citadine : 1
    # luxe : 0.5906
    # routi�re : 0.8959
    # sportive : 0.6049
  
  # Mesure de Classification Accuracy (globale) : 0.8513


# Conclusion : l'indice AUC obtenu avec le param�trage 2 est l�g�rement meilleur que celui obtenu 
# avec le param�trage 1. Les autres r�sultats sont identiques donc on peut retenir le param�trage 2
# pour la classification de type Random Forest.


#-----------------------------------------------------------#
#  Evaluation du classifieur : Support Vector Machines
#-----------------------------------------------------------#


            #----------------#
            #  Param�trage 1
            #----------------#

# Apprentissage du classifeur de type svm
svm <- svm(categorie~., ventes_EA, probability=TRUE, cost=12)

# Test du classifieur : classe pr�dite
result.svm <- predict(svm, ventes_ET, type="response")

# Matrice de confus
confusionMatrix(ventes_ET$categorie, result.svm)

# Test du classifieur : probabilit�s pour chaque pr�diction
svm_prob <- predict(svm, ventes_ET, probability=TRUE)

# Recuperation des probabilit�s associ�es aux pr�dictions
svm_prob <- attr(svm_prob, "probabilities")

# Conversion en un data frame  
svm_prob <- as.data.frame (svm_prob)

# Calcul de l'AUC 
auc.svm_pred <- multiclass.roc(ventes_ET$categorie, svm_prob)
print(auc.svm_pred)

# R�sultats : 

  # Indice AUC : 0.9475
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
  
    # citadine : 0.9998
    # luxe : 1
    # routi�re : 0.7217
    # sportive : 0.7957
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 
  
    # citadine : 1
    # luxe : 0.5906
    # routi�re : 0.8961
    # sportive : 0.6049
  
  # Mesure de Classification Accuracy (globale) : 0.8513

  # Note : temps d'apprentissage tr�s long 


              #----------------#
              #  Param�trage 2
              #----------------#


# Apprentissage du classifeur de type svm
svm <- svm(categorie~., ventes_EA, probability=TRUE, cost=18)

# Test du classifieur : classe pr�dite
result.svm <- predict(svm, ventes_ET, type="response")

# Matrice de confus
confusionMatrix(ventes_ET$categorie, result.svm)

# Test du classifieur : probabilit�s pour chaque pr�diction
svm_prob <- predict(svm, ventes_ET, probability=TRUE)

# Recuperation des probabilit�s associ�es aux pr�dictions
svm_prob <- attr(svm_prob, "probabilities")

# Conversion en un data frame  
svm_prob <- as.data.frame (svm_prob)

# Calcul de l'AUC 
auc.svm_pred <- multiclass.roc(ventes_ET$categorie, svm_prob)
print(auc.svm_pred)

# R�sultats : 

  # Indice AUC : 0.9479
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
  
    # citadine : 0.9998
    # luxe : 1
    # routi�re : 0.7216
    # sportive : 0.7957
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 
  
    # citadine : 1
    # luxe : 0.5906
    # routi�re : 0.8961
    # sportive : 0.6049
  
  # Mesure de Classification Accuracy (globale) : 0.8513
  
  # Note : temps d'apprentissage tr�s long 

#-----------------------------------------------------------#
#  Evaluation du classifieur : Naive Bayes
#-----------------------------------------------------------#


          #----------------#
          #  Param�trage 1
          #----------------#

# Apprentissage du classifeur de type Naive Bayes
nb <- naive_bayes(categorie~., ventes_EA, laplace=12)

# Test du classifieur : classe pr�dite 
nb_class <- predict(nb,ventes_ET, type="class")

# Matrice de confusion 
confusionMatrix(ventes_ET$categorie, nb_class)

# Test du classifieur : probabilites pour chaque prediction 
nb_prob <- predict(nb, ventes_ET, type="prob")

# Calcul de l'AUC 
auc.nb_pred <- multiclass.roc(ventes_ET$categorie, nb_prob)
print(auc.nb_pred)

# R�sultats : 

  # Indice AUC : 0.9154
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
    
    # citadine : 0.8707
    # luxe : 0.6778
    # routi�re : 0.7125
    # sportive : 0.6549
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 
  
    # citadine : 0.8883
    # luxe : 0.6789
    # routi�re : 0.7457
    # sportive : 0.5701
  
  # Mesure de Classification Accuracy (globale) : 0.7571

        #----------------#
        #  Param�trage 2
        #----------------#


# Apprentissage du classifeur de type Naive Bayes
nb <- naive_bayes(categorie~., ventes_EA, laplace=30)

# Test du classifieur : classe pr�dite 
nb_class <- predict(nb,ventes_ET, type="class")

# Matrice de confusion 
confusionMatrix(ventes_ET$categorie, nb_class)

# Test du classifieur : probabilites pour chaque prediction 
nb_prob <- predict(nb, ventes_ET, type="prob")

# Calcul de l'AUC 
auc.nb_pred <- multiclass.roc(ventes_ET$categorie, nb_prob)
print(auc.nb_pred)

# R�sultats : 
  
  # Indice AUC : 0.9151
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
  
    # citadine : 0.8658
    # luxe : 0.6277
    # routi�re : 0.7126
    # sportive : 0.6547
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 

  # citadine : 0.8883
  # luxe : 0.6789
  # routi�re : 0.7409
  # sportive : 0.5701

# Mesure de Classification Accuracy (globale) : 0.7555

#-----------------------------------------------------------#
#  Evaluation du classifieur : Neural Networks
#-----------------------------------------------------------#
        
        #----------------#
        #  Param�trage 1
        #----------------#

# Apprentissage du classifeur de type nn
nn <- nnet(categorie~., ventes_EA, size=12)

# Test du classifieur : classe predite
result.nn <- predict(nn, ventes_ET, type="class")

# On met les pr�dictions en facteur pour cr�er la matrice de confusion
result.nn <- as.factor(result.nn)

# Matrice de confusion
confusionMatrix(ventes_ET$categorie, result.nn)
 
# Test du classifieur : probabilites pour chaque prediction
nn_prob <- predict(nn, ventes_ET, type="raw")

# Calcul de l'AUC 
auc.nn_pred <- multiclass.roc(ventes_ET$categorie, nn_prob)
print(auc.nn_pred)

# R�sultats : 

  # Indice AUC : 0.9483

  # Mesure de Rappel pour chaque classe (sensitivity) : 
  
    # citadine : 0.9998
    # luxe : 0.9981
    # routi�re : 0.7215
    # sportive : 0.7957
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 
  
    # citadine : 1
    # luxe : 0.5906
    # routi�re : 0.8959
    # sportive : 0.6049
  
  # Mesure de Classification Accuracy (globale) : 0.7589  

            #----------------#
            #  Param�trage 2
            #----------------#


# Apprentissage du classifeur de type nn
nn <- nnet(categorie~., ventes_EA, size=18) 

# Test du classifieur : classe predite
result.nn <- predict(nn, ventes_ET, type="class")

# On met les pr�dictions en facteur pour cr�er la matrice de confusion
result.nn <- as.factor(result.nn)

# Matrice de confusion
confusionMatrix(ventes_ET$categorie, result.nn)

# Test du classifieur : probabilites pour chaque prediction
nn_prob <- predict(nn, ventes_ET, type="raw")

# Calcul de l'AUC 
auc.nn_pred <- multiclass.roc(ventes_ET$categorie, nn_prob)
print(auc.nn_pred)

# R�sultats : 

  # Indice AUC : 0.9492
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
    
    # citadine : 0.9998
    # luxe : 0.99806
    # routi�re : 0.7215
    # sportive : 0.7957
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 
  
    # citadine : 1
    # luxe : 0.5906
    # routi�re : 0.8959
    # sportive : 0.6049
  
  # Mesure de Classification Accuracy (globale) : 0.7807 


#-----------------------------------------------------------#
#  Evaluation du classifieur : k-nearest neighbors
#-----------------------------------------------------------#

                #----------------#
                #  Param�trage 1
                #----------------#


# Apprentissage et test simultan�s du classifeur de type k-nearest neighbors 
kknn <- kknn(categorie~., ventes_EA, ventes_ET, k=12) 

# Matrice de confusion 
confusionMatrix(ventes_ET$categorie, kknn$fitted.values)

# Conversion des probabilit�s en data frame 
kknn_prob <- as.data.frame(kknn$prob)

# Calcul de l'AUC 
auc.kknn_pred <- multiclass.roc(ventes_ET$categorie, kknn_prob)
print(auc.kknn_pred)

# R�sultats : 
  
  # Indice AUC : 0.9374
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
    
      # citadine : 0.9998
      # luxe : 0.8086
      # routi�re : 0.7071
      # sportive : 0.7279
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 
  
      # citadine : 1
      # luxe : 0.6640
      # routi�re : 0.8207
      # sportive : 0.5915
  
  # Mesure de Classification Accuracy (globale) : 0.7489

              #----------------#
              #  Param�trage 2
              #----------------#


# Apprentissage et test simultan�s du classifeur de type k-nearest neighbors 
kknn <- kknn(categorie~., ventes_EA, ventes_ET, k=256) 

# Matrice de confusion 
confusionMatrix(ventes_ET$categorie, kknn$fitted.values)

# Conversion des probabilit�s en data frame 
kknn_prob <- as.data.frame(kknn$prob)

# Calcul de l'AUC 
auc.kknn_pred <- multiclass.roc(ventes_ET$categorie, kknn_prob)
print(auc.kknn_pred)

# R�sultats : 

  # Indice AUC : 0.9443
  
  # Mesure de Rappel pour chaque classe (sensitivity) : 
  
    # citadine : 0.9972
    # luxe : 0.9980
    # routi�re : 0.7220
    # sportive : 0.7928
  
  # Mesure de Pr�cision pour chaque classe (Pos pred value) : 
    
    # citadine : 1
    # luxe : 0.5814
    # routi�re : 0.8943
    # sportive : 0.6049
  
  # Mesure de Classification Accuracy (globale) : 0.8501 




#------------------------------------------------------------------#
#  6. Application du mod�le de pr�diction au fichier Marketing.csv
#------------------------------------------------------------------#


# Mod�le de pr�diction choisi : tree_c50_4


# Classes pr�dites
predictions_marketing <- predict(tree_C50_4, marketing, type="class")
table(predictions_marketing)

# Probabilit�s pour chaque classe pr�dite
probabilites_marketing <- predict(tree_C50_4, marketing, type="prob")
probabilites_marketing

# Cr�ation d'un nouveau data frame avec les r�sultats
resultats_marketing <- data.frame(marketing, predictions_marketing, probabilites_marketing)

# Exportation des r�sultats dans un fichier csv
write.table(
  resultats_marketing, 
  file = "resultats_marketing.csv", 
  sep = ";", 
  dec = ".",
  row.names = F)

