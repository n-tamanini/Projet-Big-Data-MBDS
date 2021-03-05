-- création de la table externe HIVE pointant vers le fichier HDFS /projet_big_data_immatriculation/Immatriculations.csv


-- lancer Hive

[oracle@bigdatalite ~]$ beeline
Beeline version 1.1.0-cdh5.4.0 by Apache Hive

-- Se connecter à HIVE

beeline>   !connect jdbc:hive2://localhost:10000

Enter username for jdbc:hive2://localhost:10000: oracle
Enter password for jdbc:hive2://localhost:10000: ********
(password : welcome1)

-- créer la table externe HIVE pointant vers le fichier Immarticulations.csv

-- table externe Hive IMMATRICULATION
drop table IMMATRICULATION;

CREATE EXTERNAL TABLE IMMATRICULATION (IMMATRICULATION STRING, MARQUE STRING,  NOM STRING, PUISSANCE  int, LONGUEUR STRING, NBPORTES int, NBPLACES int, COULEUR STRING, OCCASION STRING, PRIX INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION 'hdfs:/projet_big_data_immatriculation';

-- Vérification de la table externe IMMATRICULATION dans HIVE

jdbc:hive2://localhost:10000> SELECT COUNT(*) FROM IMMATRICULATION;

+----------+--+
|   _c0    |
+----------+--+
| 2000001  |
+----------+--+
1 row selected (48.935 seconds)


jdbc:hive2://localhost:10000> SELECT * FROM IMMATRICULATION WHERE IMMATRICULATION.IMMATRICULATION = '4030 YB 47';

+----------------------------------+-------------------------+----------------------+----------------------------+---------------------------+---------------------------+---------------------------+--------------------------+---------------------------+-----------------------+--+
| immatriculation.immatriculation  | immatriculation.marque  | immatriculation.nom  | immatriculation.puissance  | immatriculation.longueur  | immatriculation.nbportes  | immatriculation.nbplaces  | immatriculation.couleur  | immatriculation.occasion  | immatriculation.prix  |
+----------------------------------+-------------------------+----------------------+----------------------------+---------------------------+---------------------------+---------------------------+--------------------------+---------------------------+-----------------------+--+
| 4030 YB 47                       | Volvo                   | S80 T6               | 272                        | tr�s longue               | 5                         | 5                         | bleu                     | false                     | 50500                 |
+----------------------------------+-------------------------+----------------------+----------------------------+---------------------------+---------------------------+---------------------------+--------------------------+---------------------------+-----------------------+--+
1 row selected (2.409 seconds)
