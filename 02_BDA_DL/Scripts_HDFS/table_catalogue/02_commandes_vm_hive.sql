-- création de la table externe HIVE pointant vers le fichier HDFS /projet_big_data_catalogue/Catalogue.csv


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
STORED AS TEXTFILE LOCATION 'hdfs:/projet_big_data_catalogue'
tblproperties ("skip.header.line.count"="1");


-- Vérification de la table externe CATALOGUE dans HIVE

jdbc:hive2://localhost:10000> SELECT COUNT(*) FROM CATALOGUE;

+------+--+
| _c0  |
+------+--+
| 270  |
+------+--+

1 row selected (49.077 seconds)


jdbc:hive2://localhost:10000> SELECT * FROM CATALOGUE WHERE CATALOGUE.MARQUE = 'Volvo';

+-------------------+----------------+----------------------+---------------------+---------------------+---------------------+--------------------+---------------------+-----------------+--+
| catalogue.marque  | catalogue.nom  | catalogue.puissance  | catalogue.longueur  | catalogue.nbportes  | catalogue.nbplaces  | catalogue.couleur  | catalogue.occasion  | catalogue.prix  |
+-------------------+----------------+----------------------+---------------------+---------------------+---------------------+--------------------+---------------------+-----------------+--+
| Volvo             | S80 T6         | 272                  | tr�s longue         | 5                   | 5                   | blanc              | false               | 50500           |
| Volvo             | S80 T6         | 272                  | tr�s longue         | 5                   | 5                   | noir               | false               | 50500           |
| Volvo             | S80 T6         | 272                  | tr�s longue         | 5                   | 5                   | rouge              | false               | 50500           |
| Volvo             | S80 T6         | 272                  | tr�s longue         | 5                   | 5                   | gris               | true                | 35350           |
| Volvo             | S80 T6         | 272                  | tr�s longue         | 5                   | 5                   | bleu               | true                | 35350           |
| Volvo             | S80 T6         | 272                  | tr�s longue         | 5                   | 5                   | gris               | false               | 50500           |
| Volvo             | S80 T6         | 272                  | tr�s longue         | 5                   | 5                   | bleu               | false               | 50500           |
| Volvo             | S80 T6         | 272                  | tr�s longue         | 5                   | 5                   | rouge              | true                | 35350           |
| Volvo             | S80 T6         | 272                  | tr�s longue         | 5                   | 5                   | blanc              | true                | 35350           |
| Volvo             | S80 T6         | 272                  | tr�s longue         | 5                   | 5                   | noir               | true                | 35350           |
+-------------------+----------------+----------------------+---------------------+---------------------+---------------------+--------------------+---------------------+-----------------+--+
10 rows selected (0.665 seconds)