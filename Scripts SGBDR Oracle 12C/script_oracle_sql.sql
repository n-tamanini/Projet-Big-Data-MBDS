
--------------------------------------------------------------------------------
-- Création de l'utilisateur GROUPE1_PROJET_BIG_DATA sur la plugable PDBEST21 --
--------------------------------------------------------------------------------

-- Etant TAMANINI2B20
CREATE USER GROUPE1_PROJET_BIG_DATA IDENTIFIED BY GROUPE1_PROJET_BIG_DATA01 
DEFAULT tablespace users 
TEMPORARY tablespace temp;

SELECT * FROM all_users;

GRANT CREATE SESSION TO GROUPE1_PROJET_BIG_DATA WITH ADMIN OPTION;

GRANT CREATE TABLE TO GROUPE1_PROJET_BIG_DATA;

ALTER USER GROUPE1_PROJET_BIG_DATA quota unlimited ON users;

-- Etant GROUPE1_PROJET_BIG_DATA
GROUPE1_PROJET_BIG_DATA@PDBEST21/GROUPE1_PROJET_BIG_DATA01