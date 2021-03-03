-- création d'une directory hadoop
$ hdfs dfs -mkdir /projet_big_data

-- ajout du  fichier Immarticulations.csv dans hdfs

-- suppression du fichier si vous souhaitez le remplacer
$ hdfs dfs -rm /projet_big_data/Immarticulations.csv

-- ajout du fichier 
$ hdfs dfs -put /home/oracle/data_group_1/Immatriculations.csv /projet_big_data

--  Vérification de l'ajout.
$ hdfs dfs -ls /projet_big_data
-- Réponse : 
Found 1 items
-rw-r--r--   1 oracle supergroup  120957648 2021-03-03 05:37 /projet_big_data/Immatriculations.csv


