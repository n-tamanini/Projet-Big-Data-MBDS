OPTIONS (SKIP=1, ERRORS=100000)
LOAD DATA
INFILE 'C:\data_groupe_1\Clients_0.csv'
INSERT INTO TABLE client
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    age, 
    sexe, 
    taux,
    situationFamiliale,
    nbEnfantsAcharge,
    deuxiemeVoiture,
    immatriculation
)