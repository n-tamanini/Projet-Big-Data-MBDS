--MongoDB

--création de la base concessionnaire
use concessionnaire

--création d'une collection
db.createCollection("catalogue")


--import du fichier immatriculation.csv (dans un invite de commandes)

--Faire la requête suivante dans un cmd
mongoimport -d concessionnaire -c catalogue --type csv --file "C:/data_group_1/catalogue.csv" --headerline

 
--Vérification de l'import (dans MongoDB)
db.catalogue.find()

--HIVE

!connect jdbc:hive2://localhost:10000


drop table catalogue;

CREATE EXTERNAL TABLE catalogue
( 
    marque STRING,
    nom STRING,
    puissance STRING,
    longueur STRING,
    nbPlaces STRING,
    nbPortes STRING,
    couleur STRING,
    occasion STRING,
    prix STRING
)
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"marque":"marque", "nom":"nom", "puissance":"puissance", "longueur":"longueur", "nbPlaces":"nbPlaces", "nbPortes":"nbPortes", "couleur":"couleur", "occasion":"occasion", "prix":"prix"}')
TBLPROPERTIES(
  "mongo.uri"="mongodb://198.168.1.11:27017/concessionnaire.catalogue"
  );







