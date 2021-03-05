-- création de la table externe HIVE pointant vers le fichier HDFS /projet_big_data/Immatriculations.csv


-- lancer Hive

[oracle@bigdatalite ~]$ beeline
Beeline version 1.1.0-cdh5.4.0 by Apache Hive

-- Se connecter à HIVE

beeline>   !connect jdbc:hive2://localhost:10000

Enter username for jdbc:hive2://localhost:10000: oracle
Enter password for jdbc:hive2://localhost:10000: ********
(password : welcome1)


-- créer la table externe HIVE pointant vers le fichier CATALOGUE.csv

-- table externe Hive CATALOGUE
drop table CATALOGUE;

CREATE EXTERNAL TABLE CATALOGUE( MARQUE STRING,  NOM STRING, PUISSANCE  int, LONGUEUR STRING, NBPORTES int, NBPLACES int, COULEUR STRING, OCCASION STRING, PRIX INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION 'hdfs:/projet_big_data';

-- Vérification de la table externe IMMATRICULATION dans HIVE

jdbc:hive2://localhost:10000> SELECT COUNT(*) FROM CATALOGUE