--------------------------------------------------------------------------------------------------------------------------------------
-- Création de la table externe HIVE pointant vers la table MARKETING de ORACLE NOSQL (importée dans 01_commandes_oracle_nosql.sql) --
--------------------------------------------------------------------------------------------------------------------------------------

-- Sur la machine virtuelle Oracle@BigDataLite (en local)

[oracle@bigdatalite ~]$ beeline
Beeline version 1.1.0-cdh5.4.0 by Apache Hive 

-- Se connecter à HIVE
beeline> !connect jdbc:hive2://localhost:10000

Enter username for jdbc:hive2://localhost:10000: oracle
Enter password for jdbc:hive2://localhost:10000: ********
(password : welcome1)

-- Supprimer la table MARKETING si elle existe déjà
jdbc:hive2://localhost:10000> drop table MARKETING; 

-- Création de la table externe MARKETING pointant vers la table MARKETING de ORACLE NOSQL
jdbc:hive2://localhost:10000> CREATE EXTERNAL TABLE MARKETING(
    CLIENTMARKETINGID int,
    AGE string ,
    SEXE string, 
    TAUX string,
    SITUATIONFAMILIALE string,
    NBENFANTSACHARGE string,
    DEUXIEMEVOITURE string
)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "bigdatalite.localdomain:5000", 
"oracle.kv.hadoop.hosts" = "bigdatalite.localdomain/127.0.0.1", 
"oracle.kv.tableName" = "MARKETING");


-- Vérification du contenu de la table MARKETING externe dans HIVE
0: jdbc:hive2://localhost:10000> select * from MARKETING;


-- Réponse :

+------------------------------+----------------+-----------------+-----------------+-------------------------------+-----------------------------+----------------------------+--+
| marketing.clientmarketingid  | marketing.age  | marketing.sexe  | marketing.taux  | marketing.situationfamiliale  | marketing.nbenfantsacharge  | marketing.deuxiemevoiture  |
+------------------------------+----------------+-----------------+-----------------+-------------------------------+-----------------------------+----------------------------+--+
| 10                           | 64             | M               | 559             | C�libataire                   | 0                           | false                      |
| 19                           | 54             | F               | 452             | En Couple                     | 3                           | true                       |
| 17                           | 22             | M               | 411             | En Couple                     | 3                           | true                       |
| 14                           | 19             | F               | 212             | C�libataire                   | 0                           | false                      |
| 9                            | 43             | F               | 431             | C�libataire                   | 0                           | false                      |
| 20                           | 35             | M               | 589             | C�libataire                   | 0                           | false                      |
| 21                           | 59             | M               | 748             | En Couple                     | 0                           | true                       |
| 2                            | 21             | F               | 1396            | C�libataire                   | 0                           | false                      |
| 12                           | 79             | F               | 981             | En Couple                     | 2                           | false                      |
| 18                           | 58             | M               | 1192            | En Couple                     | 0                           | false                      |
| 15                           | 34             | F               | 1112            | En Couple                     | 0                           | false                      |
| 4                            | 48             | M               | 401             | C�libataire                   | 0                           | false                      |
| 7                            | 27             | F               | 153             | En Couple                     | 2                           | false                      |
| 8                            | 59             | F               | 572             | En Couple                     | 2                           | false                      |
| 11                           | 22             | M               | 154             | En Couple                     | 1                           | false                      |
| 13                           | 55             | M               | 588             | C�libataire                   | 0                           | false                      |
| 16                           | 60             | M               | 524             | En Couple                     | 0                           | true                       |
| 3                            | 35             | M               | 223             | C�libataire                   | 0                           | false                      |
| 5                            | 26             | F               | 420             | En Couple                     | 3                           | true                       |
| 1                            | age            | sexe            | taux            | situationFamiliale            | nbEnfantsAcharge            | 2eme voiture               |
| 6                            | 80             | M               | 530             | En Couple                     | 3                           | false                      |
+------------------------------+----------------+-----------------+-----------------+-------------------------------+-----------------------------+----------------------------+--+
21 rows selected (2.793 seconds)
