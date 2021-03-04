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