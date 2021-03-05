-- création d'une directory hadoop

$ hdfs dfs -mkdir /projet_big_data_catalogue

-- ajout du  fichier Catalogue.csv dans hdfs

-- suppression du fichier si vous souhaitez le remplacer
$ hdfs dfs -rm /projet_big_data_catalogue/Catalogue.csv

-- ajout du fichier 
$ hdfs dfs -put /home/oracle/data_group_1/Catalogue.csv /projet_big_data_catalogue

--  Vérification de l'ajout.
$ hdfs dfs -ls /projet_big_data_catalogue
-- Réponse : 
--Found 1 items
---rw-r--r--   1 oracle supergroup      14114 2021-03-05 04:34 /projet_big_data_catalogue/Catalogue.csv
