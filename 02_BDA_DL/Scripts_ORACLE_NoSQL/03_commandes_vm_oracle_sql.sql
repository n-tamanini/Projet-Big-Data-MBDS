-------------------------------------------------------------------------------------------------------------------------------
-- Création de la table externe ORACLE SQL pointant vers la table MARKETING de HIVE (importée dans 02_commandes_vm_hive.sql) --
-------------------------------------------------------------------------------------------------------------------------------

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

-- table externe Oracle SQL MARKETING_EXT pointant vers la table 
-- externe HIVE correspondante (MARKETING)
drop table MARKETING_EXT;

CREATE TABLE  MARKETING_EXT(
    CLIENTMARKETINGID number(5), 
    AGE number(2),
    SEXE varchar2(30),
    TAUX number(8),
    SITUATIONFAMILIALE varchar2(30), 
    NBENFANTSACHARGE number(2),
    DEUXIEMEVOITURE varchar2(10)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_HIVE 
    DEFAULT DIRECTORY ORACLE_BIGDATA_CONFIG
    ACCESS PARAMETERS 
(
    com.oracle.bigdata.tablename=default.MARKETING
)
) 
REJECT LIMIT UNLIMITED;



-- Vérification du nombre de lignes de la table MARKETING_EXT
select count (*) from MARKETING_EXT;

  COUNT(*)
----------
	21


-- Vérification du contenu de la table MARKETING_EXT
set linesize 150
set pagesize 100
select * from MARKETING_EXT;

CLIENTMARKETINGID	 AGE SEXE	TAUX            SITUATIONFAMILIALE	 NBENFANTSACHARGE DEUXIEMEVO
----------------- ---------- -------------------------- ---------- ---------------------------- 
	       17	  22 M					   411 En Couple				     3 true
	       10	  64 M					   559 C?libataire				     0 false
	       19	  54 F					   452 En Couple				     3 true
	       14	  19 F					   212 C?libataire				     0 false
		    9	  43 F					   431 C?libataire				     0 false
	       20	  35 M					   589 C?libataire				     0 false
	       21	  59 M					   748 En Couple				     0 true
	       15	  34 F					  1112 En Couple				     0 false
		    2	  21 F					  1396 C?libataire				     0 false
	       12	  79 F					   981 En Couple				     2 false
	       18	  58 M					  1192 En Couple				     0 false
	    	4	  48 M					   401 C?libataire				     0 false
	    	7	  27 F					   153 En Couple				     2 false
	    	8	  59 F					   572 En Couple				     2 false
	       11	  22 M					   154 En Couple				     1 false
	       13	  55 M					   588 C?libataire				     0 false
	       16	  60 M					   524 En Couple				     0 true
		    3	  35 M					   223 C?libataire				     0 false
		    5	  26 F					   420 En Couple				     3 true
		    1	     sexe				       situationFamiliale
		    6	  80 M					   530 En Couple				     3 false

21 rows selected.


-- Vérification de la structure de la table MARKETING_EXT
desc MARKETING_EXT;

 Name					   Null?    Type
 ----------------------------------------- -------- 
 CLIENTMARKETINGID				    NUMBER(5)
 AGE						        NUMBER(2)
 SEXE						        VARCHAR2(30)
 TAUX						        NUMBER(8)
 SITUATIONFAMILIALE				    VARCHAR2(30)
 NBENFANTSACHARGE				    NUMBER(2)
 DEUXIEMEVOITURE				    VARCHAR2(10)