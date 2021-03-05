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