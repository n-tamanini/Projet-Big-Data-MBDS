-- création d'une directory hadoop

$ hdfs dfs -mkdir /projet_big_data_immatriculation

-- ajout du  fichier Immarticulations.csv dans hdfs

-- suppression du fichier si vous souhaitez le remplacer
$ hdfs dfs -rm /projet_big_data_immatriculation/Immarticulations.csv

-- ajout du fichier 
$ hdfs dfs -put /home/oracle/data_group_1/Immatriculations.csv /projet_big_data_immatriculation

--  Vérification de l'ajout.
$ hdfs dfs -ls /projet_big_data_immatriculation
-- Réponse : 
--Found 1 items
---rw-r--r--   1 oracle supergroup  120957648 2021-03-05 04:40 /projet_big_data_immatriculation/Immatriculations.csv



