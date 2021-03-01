-- Création de la table client (dans sqldeveloper)
CREATE TABLE client(
    age number(2), 
    sexe varchar2(20), 
    taux number(5),
    situationFamiliale varchar2(20),
    nbEnfantsAcharge number(2),
    deuxiemeVoiture varchar2(20),
    immatriculation varchar2(20)
    ); 

-- Import des données dans la table client depuis Clients_0.csv via sqlloader (Dans un invite de commandes)
sqlldr userid=GROUPE1_PROJET_BIG_DATA@PDBEST21/GROUPE1_PROJET_BIG_DATA01 control=control.ctl log=track.log
