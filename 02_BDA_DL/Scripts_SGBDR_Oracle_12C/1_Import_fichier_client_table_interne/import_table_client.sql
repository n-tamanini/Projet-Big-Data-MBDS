sqlplus /nolog

define MYDBUSER=GROUPE1_PROJET
define MYDB=orcl
define MYDBUSERPASS=GROUPE1_PROJET01

connect &MYDBUSER@&MYDB/&MYDBUSERPASS

-- Création de la table client (dans ORACLE SQL sur la machine virtuelle)
DROP TABLE CLIENT CASCADE CONSTRAINTS;

CREATE TABLE CLIENT (
	AGE  number(2), 
	SEXE varchar2(30),
	TAUX number(8),
	SITUATIONFAMILIALE varchar2(30),
	NBENFANTSACHARGE number(2),
	DEUXIEMEVOITURE varchar2(10),
	IMMATRICULATION varchar2(100) 
);

-- Import des données dans la table client depuis Clients_0.csv via sqlloader
-- Les données Clients_0.csv ont été placées dans le répertoire suivant sur la machine virtuelle (en local) : /home/oracle/data_group_1/Clients_0.csv

-- Dans un invite de commandes sur la machine virtuelle (oracle@bigdatalite): 
MYDBUSER=GROUPE1_PROJET
MYDB=orcl
MYDBUSERPASS=GROUPE1_PROJET01
MYPROJECTPATH=/home/oracle/Projet-Big-Data-MBDS

cd $MYPROJECTPATH/02_BDA_DL/Scripts_SGBDR_Oracle_12C/1_Import_fichier_client_table_interne

sqlldr userid=$MYDBUSER@$MYDB/$MYDBUSERPASS control=control.ctl log=track.log



-- Vérification de l'import de la table interne CLIENT 

sqlplus /nolog

define MYDBUSER=GROUPE1_PROJET
define MYDB=orcl
define MYDBUSERPASS=GROUPE1_PROJET01

connect &MYDBUSER@&MYDB/&MYDBUSERPASS

SQL> select count (*) from client;

  COUNT(*)
----------
     99710

desc client;

 Name						       Null?	Type
 ----------------------------------------------------- --------
 AGE								NUMBER(2)
 SEXE								VARCHAR2(30)
 TAUX								NUMBER(8)
 SITUATIONFAMILIALE					VARCHAR2(30)
 NBENFANTSACHARGE					NUMBER(2)
 DEUXIEMEVOITURE					VARCHAR2(10)
 IMMATRICULATION					VARCHAR2(100)


select * from client where age = 84;

-- Extrait de la réponse : 

AGE       SEXE 		TAUX 		SITUATIONFAMILIALE 	    NBENFANTSACHARGE 	DEUXIEMEVO      IMMATRICULATION 
-------- ------------------------------ ---------- ------------------------------ ---------------- ----------  
84  	   M		563 		En Couple			     0                	false            7905 DR 45
