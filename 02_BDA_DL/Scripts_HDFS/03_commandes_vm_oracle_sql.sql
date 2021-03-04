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



SELECT * FROM IMMATRICULATION_EXT WHERE IMMATRICULATION = '4030 YB 47';

IMMATRICULATION 										     MARQUE	     NOM			     PUISSANCE LONGUEUR 	      NBPLACES
------------------------------------------------------------------------------------------------ --------------- ------------------------------ ---------- -------------------- ----------
  NBPORTES COULEUR    OCCASION	       PRIX
---------- ---------- ---------- ----------
4030 YB 47											     Volvo	     S80 T6				   272 tr?longue		     5
	 5 bleu       false	      50500





select count (*) from IMMATRICULATION_EXT;

  COUNT(*)
----------
   2000001
