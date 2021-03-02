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
 
    javac -g -cp $KVHOME/lib/kvclient.jar:/home/oracle/Projet-Big-Data-MBDS/02_BDAHDFS/Scripts_ORACLE_NoSQL /home/oracle/Projet-Big-Data-MBDS/02_BDAHDFS/Scripts_ORACLE_NoSQL/immatriculation.java


    mkdir -p C:/GitHub/Projet-Big-Data-MBDS/02_BDAHDFS

 
    mv immatriculation*.classs C:/GitHub/Projet-Big-Data-MBDS/02_BDAHDFS
    
    jar -cvf immatriculation.jar -C . org