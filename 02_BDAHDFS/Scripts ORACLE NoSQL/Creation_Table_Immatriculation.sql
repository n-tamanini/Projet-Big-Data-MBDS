-- Sur la machine virtuelle Oracle@BigDataLite

-- Connection à Oracle NoSQL
java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host bigdatalite.localdomain

kv->connect store -name kvstore

-- Création de la table IMMATRICULATION dans Oracle NoSQL
kv->execute 'CREATE TABLE IF NOT EXISTS IMMATRICULATION (
    immatriculation STRING,
    marque STRING,
    nom STRING,
    puissance INTEGER,
    longueur STRING,
    nbPlaces INTEGER,
    nbPortes INTEGER,
    couleur STRING,
    occasion STRING,
    prix INTEGER,
    PRIMARY KEY(immatriculation)
)';

-- Import des données dans la table IMMATRICULATION depuis le fichier csv correspondant
import -table IMMATRICULATION -file C:\data_group_1\Immatriculation.csv CSV
