-------------------------------------------------------------------------------------------------------------------------------------
-- Création de la table externe ORACLE SQL pointant vers la table CATALOGUE de HIVE (importée dans 02_commandes_vm_hive.sql) --
-------------------------------------------------------------------------------------------------------------------------------------

-- Dans la machine virtuelle oracle@bigdatalite (local)
-- Dans un invite de commandes
-- Connexion à l'utilisateur GROUPE1_PROJET
sqlplus /nolog

define MYDBUSER=GROUPE1_PROJET
define MYDB=orcl
define MYDBUSERPASS=GROUPE1_PROJET01

connect &MYDBUSER@&MYDB/&MYDBUSERPASS

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


-- table externe Oracle SQL CATALOGUE_EXT pointant vers la table 
-- externe HIVE correspondante CATALOGUE

drop table CATALOGUE_EXT;

CREATE TABLE CATALOGUE_EXT(
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
    com.oracle.bigdata.tablename=default.CATALOGUE
)
) 
REJECT LIMIT UNLIMITED;


-- Vérification de la structure de la table CATALOGUE_EXT
desc CATALOGUE_EXT;

Name      Null? Type         
--------- ----- ------------ 
MARQUE          VARCHAR2(15) 
NOM             VARCHAR2(30) 
PUISSANCE       NUMBER(3)    
LONGUEUR        VARCHAR2(20) 
NBPLACES        NUMBER(2)    
NBPORTES        NUMBER(2)    
COULEUR         VARCHAR2(10) 
OCCASION        VARCHAR2(10) 
PRIX            NUMBER(8) 


-- Vérification du nombre de lignes de la table CATALOGUE_EXT
SELECT COUNT(*) FROM CATALOGUE_EXT;

  COUNT(*)
----------
       271


-- Vérification du contenu de la table CATALOGUE_EXT
set linesize 180
set pagesize 100
SELECT * FROM CATALOGUE_EXT WHERE MARQUE = 'Volvo';

MARQUE		NOM				PUISSANCE LONGUEUR		 NBPLACES   NBPORTES COULEUR	OCCASION	 PRIX
--------------- ------------------------------ ---------- -------------------- ---------- ---------- 
Volvo		S80 T6				      272 tr?longue			5	   5 blanc	false		50500
Volvo		S80 T6				      272 tr?longue			5	   5 noir	false		50500
Volvo		S80 T6				      272 tr?longue			5	   5 rouge	false		50500
Volvo		S80 T6				      272 tr?longue			5	   5 gris	true		35350
Volvo		S80 T6				      272 tr?longue			5	   5 bleu	true		35350
Volvo		S80 T6				      272 tr?longue			5	   5 gris	false		50500
Volvo		S80 T6				      272 tr?longue			5	   5 bleu	false		50500
Volvo		S80 T6				      272 tr?longue			5	   5 rouge	true		35350
Volvo		S80 T6				      272 tr?longue			5	   5 blanc	true		35350
Volvo		S80 T6				      272 tr?longue			5	   5 noir	true		35350

10 rows selected.
