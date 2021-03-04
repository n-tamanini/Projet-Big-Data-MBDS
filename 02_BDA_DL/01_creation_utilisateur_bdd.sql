
-----------------------------------------------------------------------------------------------------------------------------------
-- Création de l'utilisateur GROUPE1_PROJET sur la base de donnée locale orcl se la machine virtuelle oracle@bigdatalite (local) --
-----------------------------------------------------------------------------------------------------------------------------------

-- Dans la machine virtuelle oracle@bigdatalite (local)
-- Dans un invite de commandes
sqlplus /nolog

define MYDBUSER=GROUPE1_PROJET
define MYDB=orcl
define MYDBUSERPASS=GROUPE1_PROJET01

define MYCDBUSER=system
define MYCDBUSERPASS=welcome1

-- se connecter sur la base orcl en étant system
connect &MYCDBUSER@&MYDB/@MYCDBUSERPASS

-- Création du user GROUPE1_PROJET qui va contenir toutes les tables externes et internes dans ORACLE SQL
CREATE USER &MYDBUSER IDENTIFIED BY &MYDBUSERPASS 
default tablespace users
temporary tablespace temp;

grant dba to &MYDBUSER;
alter user &MYDBUSER quota unlimited on users;