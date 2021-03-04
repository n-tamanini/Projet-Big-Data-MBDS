
drop table  CATALOGUE_EXT;

CREATE TABLE CATALOGUE_EXT (
	marque varchar2(15),
	nom varchar2(30),
	puissance number(3),
	longueur varchar2(20),
	nbPlaces number(2),
	nbPortes number(2),
	couleur varchar2(10),
    occasion varchar2(10),
    prix number(8),
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
