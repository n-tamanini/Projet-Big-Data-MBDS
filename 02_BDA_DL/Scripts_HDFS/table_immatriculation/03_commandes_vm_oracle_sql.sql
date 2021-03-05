-------------------------------------------------------------------------------------------------------------------------------------
-- Création de la table externe ORACLE SQL pointant vers la table IMMATRICULATION de HIVE (importée dans 02_commandes_vm_hive.sql) --
-------------------------------------------------------------------------------------------------------------------------------------

-- Dans la machine virtuelle oracle@bigdatalite (local)
-- Dans un invite de commandes
-- Connexion à l'utilisateur GROUPE1_PROJET
sqlplus /nolog

define MYDBUSER=GROUPE1_PROJET
define MYDB=orcl
define MYDBUSERPASS=GROUPE1_PROJET01

connect &MYDBUSER@&MYDB/@MYDBUSERPASS

-- On crée les deux directories suivantes :
-- ORACLE_BIGDATA_CONFIG et 
-- ORA_BIGDATA_CL_bigdatalite. 
-- La directorie ORACLE_BIGDATA_CONFIG sert à stocker les lignes
-- rappatriées des bases distantes.

-- **************** ATTENTION, N'EXECUTER CE CODE QU'UNE FOIS **************** --
create or replace directory ORACLE_BIGDATA_CONFIG as '/u01/bigdatasql_config';
create or replace directory "ORA_BIGDATA_CL_bigdatalite" as '';
-- *************************************************************************** --

-- Vérification
select DIRECTORY_NAME from dba_directories;


-- table externe Oracle SQL IMMATRICULATION_EXT pointant vers la table 
-- externe HIVE correspondante (IMMATRICULATION)
drop table IMMATRICULATION_EXT;

CREATE TABLE IMMATRICULATION_EXT(
	IMMATRICULATION varchar2(100),
	MARQUE varchar2(15),
	NOM varchar2(30), 
	PUISSANCE number(3),
	LONGUEUR varchar2(20),
	NBPLACES number(2),
	NBPORTES number(2),
	COULEUR varchar2(10),
	OCCASION varchar2(10),
    PRIX number(8)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_HIVE 
    DEFAULT DIRECTORY ORACLE_BIGDATA_CONFIG
    ACCESS PARAMETERS 
(
    com.oracle.bigdata.tablename=default.IMMATRICULATION
)
) 
REJECT LIMIT UNLIMITED;


-- Vérification de la structure de la table IMMATRICULATION_EXT
desc IMMATRICULATION_EXT;

 Name					   Null?    Type
 ----------------------------------------- -------- ----------------------------
 IMMATRICULATION				VARCHAR2(100)
 MARQUE 					    VARCHAR2(15)
 NOM						    VARCHAR2(30)
 PUISSANCE					    NUMBER(3)
 LONGUEUR					    VARCHAR2(20)
 NBPLACES					    NUMBER(2)
 NBPORTES					    NUMBER(2)
 COULEUR					    VARCHAR2(10)
 OCCASION					    VARCHAR2(10)
 PRIX						    NUMBER(8)


-- Vérification du contenu de la table IMMATRICULATION_EXT
SELECT * FROM IMMATRICULATION_EXT WHERE IMMATRICULATION = '4030 YB 47';

IMMATRICULATION		MARQUE    NOM      PUISSANCE 	LONGUEUR 	 NBPLACES  NBPORTES COULEUR    OCCASION	  PRIX
---------------    	--------- -------  ---------- 	------------ --------  -------- ---------- ---------- ----------
4030 YB 47		   	Volvo     S80 T6   272 			tr?longue	  5         5 		bleu       false     50500
	 

-- Vérification du nombre de lignes de la table IMMATRICULATION_EXT
select count (*) from IMMATRICULATION_EXT;

  COUNT(*)
----------
   2000001
