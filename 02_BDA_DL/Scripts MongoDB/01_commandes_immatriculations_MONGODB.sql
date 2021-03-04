--MongoDB

--création de la base concessionnaire
use concessionnaire

--création d'une collection
db.createCollection("catalogue")


--import du fichier immatriculation.csv (dans un invite de commandes)

--Faire la requête suivante dans un cmd

mongoimport -d concessionnaire -c catalogue --type csv --file "Votre chemin du fichier/catalogue.csv" --headerline

 
--Vérification de l'import (dans MongoDB)
db.catalogue.find()




-- TEST >db.catalogue.find()

{ "_id" : ObjectId("603d0485327dc5228d3fb6ed"), "marque" : "Volvo", "nom" : "S80 T6", "puissance" : 272, "longueur" : "tr�s longue", "nbPlaces" : 5, "nbPortes" : 5, "couleur" : "gris", "occasion" : "true", "prix" : 35350 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6ee"), "marque" : "Volvo", "nom" : "S80 T6", "puissance" : 272, "longueur" : "tr�s longue", "nbPlaces" : 5, "nbPortes" : 5, "couleur" : "blanc", "occasion" : "false", "prix" : 50500 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6ef"), "marque" : "Volvo", "nom" : "S80 T6", "puissance" : 272, "longueur" : "tr�s longue", "nbPlaces" : 5, "nbPortes" : 5, "couleur" : "bleu", "occasion" : "true", "prix" : 35350 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6f0"), "marque" : "Volvo", "nom" : "S80 T6", "puissance" : 272, "longueur" : "tr�s longue", "nbPlaces" : 5, "nbPortes" : 5, "couleur" : "gris", "occasion" : "false", "prix" : 50500 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6f1"), "marque" : "Volvo", "nom" : "S80 T6", "puissance" : 272, "longueur" : "tr�s longue", "nbPlaces" : 5, "nbPortes" : 5, "couleur" : "bleu", "occasion" : "false", "prix" : 50500 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6f2"), "marque" : "Volvo", "nom" : "S80 T6", "puissance" : 272, "longueur" : "tr�s longue", "nbPlaces" : 5, "nbPortes" : 5, "couleur" : "rouge", "occasion" : "true", "prix" : 35350 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6f3"), "marque" : "Volvo", "nom" : "S80 T6", "puissance" : 272, "longueur" : "tr�s longue", "nbPlaces" : 5, "nbPortes" : 5, "couleur" : "blanc", "occasion" : "true", "prix" : 35350 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6f4"), "marque" : "Volvo", "nom" : "S80 T6", "puissance" : 272, "longueur" : "tr�s longue", "nbPlaces" : 5, "nbPortes" : 5, "couleur" : "rouge", "occasion" : "false", "prix" : 50500 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6f5"), "marque" : "Volvo", "nom" : "S80 T6", "puissance" : 272, "longueur" : "tr�s longue", "nbPlaces" : 5, "nbPortes" : 5, "couleur" : "noir", "occasion" : "false", "prix" : 50500 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6f6"), "marque" : "Volkswagen", "nom" : "Touran 2.0 FSI", "puissance" : 150, "longueur" : "longue", "nbPlaces" : 7, "nbPortes" : 5, "couleur" : "bleu", "occasion" : "true", "prix" : 19138 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6f7"), "marque" : "Volkswagen", "nom" : "Touran 2.0 FSI", "puissance" : 150, "longueur" : "longue", "nbPlaces" : 7, "nbPortes" : 5, "couleur" : "gris", "occasion" : "false", "prix" : 27340 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6f8"), "marque" : "Volkswagen", "nom" : "Touran 2.0 FSI", "puissance" : 150, "longueur" : "longue", "nbPlaces" : 7, "nbPortes" : 5, "couleur" : "bleu", "occasion" : "false", "prix" : 27340 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6f9"), "marque" : "Volkswagen", "nom" : "Touran 2.0 FSI", "puissance" : 150, "longueur" : "longue", "nbPlaces" : 7, "nbPortes" : 5, "couleur" : "blanc", "occasion" : "true", "prix" : 19138 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6fa"), "marque" : "Volkswagen", "nom" : "Touran 2.0 FSI", "puissance" : 150, "longueur" : "longue", "nbPlaces" : 7, "nbPortes" : 5, "couleur" : "noir", "occasion" : "true", "prix" : 19138 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6fb"), "marque" : "Volkswagen", "nom" : "Touran 2.0 FSI", "puissance" : 150, "longueur" : "longue", "nbPlaces" : 7, "nbPortes" : 5, "couleur" : "rouge", "occasion" : "true", "prix" : 19138 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6fc"), "marque" : "Volkswagen", "nom" : "Touran 2.0 FSI", "puissance" : 150, "longueur" : "longue", "nbPlaces" : 7, "nbPortes" : 5, "couleur" : "rouge", "occasion" : "false", "prix" : 27340 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6fd"), "marque" : "Volvo", "nom" : "S80 T6", "puissance" : 272, "longueur" : "tr�s longue", "nbPlaces" : 5, "nbPortes" : 5, "couleur" : "noir", "occasion" : "true", "prix" : 35350 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6fe"), "marque" : "Volkswagen", "nom" : "Polo 1.2 6V", "puissance" : 55, "longueur" : "courte", "nbPlaces" : 5, "nbPortes" : 3, "couleur" : "blanc", "occasion" : "true", "prix" : 8540 }
{ "_id" : ObjectId("603d0485327dc5228d3fb6ff"), "marque" : "Volkswagen", "nom" : "Polo 1.2 6V", "puissance" : 55, "longueur" : "courte", "nbPlaces" : 5, "nbPortes" : 3, "couleur" : "blanc", "occasion" : "false", "prix" : 12200 }
{ "_id" : ObjectId("603d0485327dc5228d3fb700"), "marque" : "Volkswagen", "nom" : "Polo 1.2 6V", "puissance" : 55, "longueur" : "courte", "nbPlaces" : 5, "nbPortes" : 3, "couleur" : "noir", "occasion" : "false", "prix" : 12200 }
Type "it" for more
>









