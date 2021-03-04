--************  NETTOYAGE TABLE CLIENT ************--

-- NETTOYAGE COLONNE SEXE

-- Les 'féminin' et 'Masculin' changent pour F et M
UPDATE CLIENT
SET sexe = 'F'
WHERE sexe LIKE 'F%minin';

UPDATE CLIENT
SET sexe = 'M'
WHERE sexe = 'Masculin';

UPDATE CLIENT
SET sexe = 'F'
WHERE sexe LIKE 'Femme';

UPDATE CLIENT
SET sexe = 'M'
WHERE sexe = 'Homme';

-- Suppression des données non conformes
DELETE FROM CLIENT
WHERE sexe NOT IN ('M','F');

-- NETTOYAGE COLONNE X2emeVoiture
-- Suppression des données non conformes
DELETE FROM CLIENT
WHERE deuxiemeVoiture NOT IN ('true','false');

--NETTOYAGE COLONNE SITUATIONFAMILIALE
--Vérification des données

SELECT DISTINCT SITUATIONFAMILIALE
FROM CLIENT;

--Les 'Seule' et 'Seul' changent pour 'Célibataire'
UPDATE CLIENT
SET SITUATIONFAMILIALE = 'Celibataire'
WHERE SITUATIONFAMILIALE IN('Seule','Seul');

 
--Suppression des données non conformes

UPDATE CLIENT
SET SITUATIONFAMILIALE = 'Celibataire'
WHERE SITUATIONFAMILIALE like 'C%libataire';

UPDATE CLIENT
SET SITUATIONFAMILIALE = 'En Couple'
WHERE SITUATIONFAMILIALE like 'Mari%(e)';

DELETE
FROM CLIENT
WHERE SITUATIONFAMILIALE NOT IN ('En Couple', 'Celibataire');

--NETTOYAGE COLONNE NBENFANTSACHARGE

--Suppression des données invalides
DELETE
FROM CLIENT
WHERE NBENFANTSACHARGE NOT BETWEEN 0 AND 4;