
---------------------------------------------------------------------------------
-- Création de l'utilisateur GROUPE1_PROJET_BIG_DATA sur la pluggable PDBEST21 --
---------------------------------------------------------------------------------

CREATE USER GROUPE1_PROJET_BIG_DATA IDENTIFIED BY GROUPE1_PROJET_BIG_DATA01 
DEFAULT tablespace users 
TEMPORARY tablespace temp;

-- Vérification de la création de l'utilisateur
SELECT * FROM all_users;

-- Attribution des privilèges
GRANT CREATE SESSION TO GROUPE1_PROJET_BIG_DATA WITH ADMIN OPTION;
GRANT CREATE TABLE TO GROUPE1_PROJET_BIG_DATA;
GRANT CREATE ANY REPOSITORY TO GROUPE1_PROJET_BIG_DATA;
ALTER USER GROUPE1_PROJET_BIG_DATA quota unlimited ON users;




/*
ALTERNATIVE SUR LA MACHINE VIRTUELLE 
*/


-- Dans la machine virtuelle oracle@bigdatalite (local)
-- Dans un invite de commandes
sqlplus system@orcl/welcome1

-- Création du user GROUPE1_PROJET qui va contenir toutes les tables externes dans ORACLE SQL
CREATE USER GROUPE1_PROJET IDENTIFIED BY GROUPE1_PROJET01 
default tablespace users
temporary tablespace temp;

grant dba to GROUPE1_PROJET;
alter user GROUPE1_PROJET quota unlimited on users;