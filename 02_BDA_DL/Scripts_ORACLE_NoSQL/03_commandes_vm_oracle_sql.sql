-- créer les deux directories suivantes si pas cré� : 
-- ORACLE_BIGDATA_CONFIG et 
-- ORA_BIGDATA_CL_bigdatalite. 
-- La directorie ORACLE_BIGDATA_CONFIG sert à stocker les lignes
-- rappatri�es des bases distantes.
-- Op�ration à faire une seule fois.
-- v�rification

$ sqlplus GROUPE1_PROJET_BIG_DATA@PDBEST21/GROUPE1_PROJET_BIG_DATA01


SQL> select DIRECTORY_NAME from dba_directories;
select * from dba_directories;
SQL> create or replace directory ORACLE_BIGDATA_CONFIG as '/u01/bigdatasql_config';
SQL> create or replace directory "ORA_BIGDATA_CL_bigdatalite" as '';

-- v�rification
SQL> select DIRECTORY_NAME from dba_directories;

-- Etape 7.1.3.4 se connecter avec votre compte si pas fait.
$ sqlplus GROUPE1_PROJET_BIG_DATA@PDBEST21/GROUPE1_PROJET_BIG_DATA01

-- Etape 7.1.3.5 r�er les tables externes Oracle CRITERES_yourLogin_MIAGE_ONS_EXT, 
-- APPRECIATIONS_yourLogin_MIAGE_ONS_EXT
-- CLIENTS_yourLogin_MIAGE_ONS_EXT pointant vers les tables externes HIVE �quivalentes.

-- table externe Oracle SQL CRITERES_yourLogin_MIAGE_ONS_EXT pointant vers la table 
-- externe HIVE
drop table MARKETING;

CREATE TABLE  MARKETING(
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








drop table marketing;

 

CREATE TABLE  marketing(
clientMarketingId NUMBER GENERATED ALWAYS AS IDENTITY constraint pk_clientMarketingId primary key,
    age     number(2) 
        constraint chk_marketing_age
        check(age BETWEEN 18 AND 84),
    sexe varchar2(30) 
        constraint chk_marketing_sexe
        check(sexe IN ('M', 'F')),
    taux number(8) 
        constraint chk_marketing_taux
        check(taux BETWEEN 544 AND 74185),
    situationFamiliale varchar2(30),
        --constraint chk_marketing_situation
        --check(situationFamiliale IN ('Célibataire', 'Divorcée', 'En Couple', 'EnCouple', 'Marié', 'Mariée', 'Seul', 'Seule')),
    nbEnfantsAcharge number(2) 
        constraint chk_marketing_nb_enfants
        check(nbEnfantsAcharge BETWEEN 0 AND 4),
    deuxiemeVoiture varchar2(10) 
        constraint chk_marketing_voiture 
        check(deuxiemeVoiture IN ('true', 'false'))
)
ORGANIZATION EXTERNAL (
TYPE ORACLE_HIVE
DEFAULT DIRECTORY   ORACLE_BIGDATA_CONFIG
ACCESS PARAMETERS
(
com.oracle.bigdata.tablename=MARKETING
)
)
REJECT LIMIT UNLIMITED;