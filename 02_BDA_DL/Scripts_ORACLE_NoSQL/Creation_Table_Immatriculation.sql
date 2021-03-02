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
 
    export MYPROJECTHOME=/home/oracle/Projet-Big-Data-MBDS

    javac -g -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/02_BDA_DL/Scripts_ORACLE_NoSQL $MYPROJECTHOME/02_BDA_DL/Scripts_ORACLE_NoSQL/Immatriculation.java

    java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/02_BDA_DL/Scripts_ORACLE_NoSQL immatriculation.Immatriculation 




    javac -g -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/02_BDA_DL $MYPROJECTHOME/02_BDA_DL/Scripts_ORACLE_NoSQL/Immatriculation.java

    java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/02_BDA_DL immatriculation.Immatriculation 



    javac -g -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/02_BDA_DL $MYPROJECTHOME/02_BDA_DL/Scripts_ORACLE_NoSQL/ImmatriculationImportData.java

    java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/02_BDA_DL immat.ImmatriculationImportData 

