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









