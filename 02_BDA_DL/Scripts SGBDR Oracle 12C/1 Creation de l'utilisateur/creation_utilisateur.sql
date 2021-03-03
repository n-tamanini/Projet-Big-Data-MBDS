
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