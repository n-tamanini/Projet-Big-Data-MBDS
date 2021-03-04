--************  NETTOYAGE TABLE CLIENT ************--

-- NETTOYAGE COLONNE SEXE

-- Les 'féminin' et 'Masculin' changent pour F et M
UPDATE CLIENT
SET sexe = 'F'
WHERE sexe LIKE 'F%minin';

UPDATE CLIENT
SET sexe = 'M'
WHERE sexe = 'Masculin';

-- Suppression des données non conformes
DELETE * FROM CLIENT
WHERE sexe != 'M' OR sexe != 'F';

-- NETTOYAGE COLONNE X2emeVoiture
-- Suppression des données non conformes
DELETE deuxiemeVoiture FROM CLIENT
WHERE deuxiemeVoiture != 'true' OR deuxiemeVoiture != 'false';


--NETTOYAGE COLONNE SITUATIONFAMILIALE
--Vérification des données

SELECT DISTINCT SITUATIONFAMILIALE
FROM CLIENT;

--Les 'Seule' et 'Seul' changent pour 'Célibataire'
UPDATE CLIENT
SET SITUATIONFAMILIALE = 'Celibataire'
WHERE SITUATIONFAMILIALE='Seule' OR 'Seul';

 
--Suppression des données non conformes
DELETE *
FROM CLIENT
WHERE SITUATIONFAMILIALE LIKE 'Divorc%e';


--NETTOYAGE COLONNE NBENFANTSACHARGE

--Suppression des données invalides
DELETE *
FROM CLIENT
WHERE NBENFANTSACHARGE NOT BETWEEN 0 AND 4;