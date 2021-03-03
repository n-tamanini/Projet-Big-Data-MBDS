-- Sur la machine virtuelle Oracle@BigDataLite

-- Dans un invite de commandes : 
 
    -- Ceci est le chemin vers notre projet sur la machine virtuelle
    [oracle@bigdatalite ~]$ export MYPROJECTHOME=/home/oracle/Projet-Big-Data-MBDS

    -- Compiler le code java pour importer la table MARKETING à partir du fichier csv
    [oracle@bigdatalite ~]$ javac -g -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/02_BDA_DL $MYPROJECTHOME/02_BDA_DL/Scripts_ORACLE_NoSQL/marketing/MarketingImportData.java

    -- Executer le code java pour importer la table MARKETING à partir du fichier csv
    [oracle@bigdatalite ~]$ java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/02_BDA_DL/Scripts_ORACLE_NoSQL marketing.MarketingImportData 

/*

REPONSE : 


****** Dans : executeDDL ********
Invalid statement:
Error: User error in query: DROP TABLE failed for table MARKETING: Table does not exist: MARKETING
****** Dans : executeDDL ********
===========================
Statement was successful:
	Create table MARKETING (CLIENTMARKETINGID INTEGER,AGE STRING,SEXE STRING,TAUX STRING,SITUATIONFAMILIALE STRING,NBENFANTSACHARGE STRING,DEUXIEMEVOITURE STRING,PRIMARY KEY (CLIENTMARKETINGID))
Results:
	Plan CreateTable MARKETING
Id:                    60                            
State:                 SUCCEEDED                     
Attempt number:        1                             
Started:               2021-03-03 09:32:45 UTC       
Ended:                 2021-03-03 09:32:45 UTC       
Total tasks:           1                             
 Successful:           1                             

********************************** Dans : loadmarketingDataFromFile *********************************
********************************** Dans : insertAmarketingRow *********************************
                                            ...
*/



-- Connection à Oracle NoSQL
[oracle@bigdatalite ~]$ java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host bigdatalite.localdomain

kv-> connect store -name kvstore

-- Vérification du contenu de la table MARKETING
kv-> get table -name MARKETING

-- Réponse :
{"CLIENTMARKETINGID":10,"AGE":"64","SEXE":"M","TAUX":"559","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":19,"AGE":"54","SEXE":"F","TAUX":"452","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":14,"AGE":"19","SEXE":"F","TAUX":"212","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":9,"AGE":"43","SEXE":"F","TAUX":"431","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":20,"AGE":"35","SEXE":"M","TAUX":"589","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":21,"AGE":"59","SEXE":"M","TAUX":"748","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":15,"AGE":"34","SEXE":"F","TAUX":"1112","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":2,"AGE":"21","SEXE":"F","TAUX":"1396","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":12,"AGE":"79","SEXE":"F","TAUX":"981","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"2","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":18,"AGE":"58","SEXE":"M","TAUX":"1192","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":4,"AGE":"48","SEXE":"M","TAUX":"401","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":7,"AGE":"27","SEXE":"F","TAUX":"153","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"2","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":8,"AGE":"59","SEXE":"F","TAUX":"572","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"2","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":11,"AGE":"22","SEXE":"M","TAUX":"154","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"1","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":13,"AGE":"55","SEXE":"M","TAUX":"588","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":16,"AGE":"60","SEXE":"M","TAUX":"524","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":3,"AGE":"35","SEXE":"M","TAUX":"223","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":5,"AGE":"26","SEXE":"F","TAUX":"420","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":1,"AGE":"age","SEXE":"sexe","TAUX":"taux","SITUATIONFAMILIALE":"situationFamiliale","NBENFANTSACHARGE":"nbEnfantsAcharge","DEUXIEMEVOITURE":"2eme voiture"}
{"CLIENTMARKETINGID":6,"AGE":"80","SEXE":"M","TAUX":"530","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":17,"AGE":"22","SEXE":"M","TAUX":"411","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"true"}

21 rows returned

/*
Ici, nous remarquons que la ligne avec CLIENTMARKETINGID:1 est la ligne des entêtes qui n'aurait pas dû être importée. 
Nous décidons de la laisser et de la trier plus tard, quand la table MARKETING aura été importée dans HIVE puis dans Oracle SQL.
*/

