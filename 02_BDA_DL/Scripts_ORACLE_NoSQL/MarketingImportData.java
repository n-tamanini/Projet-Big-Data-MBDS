package marketing;



import oracle.kv.KVStore;

import java.util.List;

import java.util.Iterator;

import oracle.kv.KVStoreConfig;

import oracle.kv.KVStoreFactory;

import oracle.kv.FaultException;

import oracle.kv.StatementResult;

import oracle.kv.table.TableAPI;

import oracle.kv.table.Table;

import oracle.kv.table.Row;

import oracle.kv.table.PrimaryKey;

import oracle.kv.ConsistencyException;

import oracle.kv.RequestTimeoutException;

import java.lang.Integer;

import oracle.kv.table.TableIterator;

import oracle.kv.table.EnumValue;

import java.io.File;

import java.io.BufferedReader;

import java.io.File;

import java.io.FileInputStream;

import java.io.FileWriter;

import java.io.IOException;

import java.io.InputStream;

import java.io.InputStreamReader;

import java.io.PrintWriter;



import java.util.StringTokenizer;

import java.util.ArrayList;

import java.util.List;





 

 public class MarketingImportData {

    private final KVStore store;



	private final String tabMarketing="MARKETING";



	

    /**

     * Runs the DDL command line program.

     */

    public static void main(String args[]) {

        try {

            MarketingImportData mark= new MarketingImportData(args);

	    mark.initMarketingTablesAndData(mark);



        } catch (RuntimeException e) {

            e.printStackTrace();

        }

    }

    /**

     * Parses command line args and opens the KVStore.

     */

	MarketingImportData(String[] argv) {



		String storeName = "kvstore";

		String hostName = "localhost";

		String hostPort = "5000";



		final int nArgs = argv.length;

		int argc = 0;

		store = KVStoreFactory.getStore

		    (new KVStoreConfig(storeName, hostName + ":" + hostPort));

	}



	

/**

* Affichage du résultat pour les commandes DDL (CREATE, ALTER, DROP)

*/

	private void displayResult(StatementResult result, String statement) {

		System.out.println("===========================");

		if (result.isSuccessful()) {

			System.out.println("Statement was successful:\n\t" +

			statement);

			System.out.println("Results:\n\t" + result.getInfo());

		} else if (result.isCancelled()) {

			System.out.println("Statement was cancelled:\n\t" +

			statement);

		} else {

			/*

			* statement was not successful: may be in error, or may still

			* be in progress.

			*/

			if (result.isDone()) {

				System.out.println("Statement failed:\n\t" + statement);

				System.out.println("Problem:\n\t" +

				result.getErrorMessage());

			}

			else {



				System.out.println("Statement in progress:\n\t" +

				statement);

				System.out.println("Status:\n\t" + result.getInfo());

			}

		}

	}

	

	/*

		La méthode initMarketingTablesAndData permet :

		- de supprimer les tables si elles existent

		- de créer des tables

        - de charger les données des marketings

	**/



	public void initMarketingTablesAndData(MarketingImportData mark) {

		mark.dropTableMarketing();

		mark.createTableMarketing();

		mark.loadmarketingDataFromFile("/home/oracle/marketing.csv"); 

	}



	/**

		public void dropTableMarketing()

		M&thode de suppression de la table marketing.

	*/	

	public void dropTableMarketing() {

		String statement = null;

		

		statement ="drop table "+tabMarketing;

		executeDDL(statement);

	}



	/**

		public void createTableMarketing()

		M&thode de création de la table marketing.

	*/



	public void createTableMarketing() {

		String statement = null;

		statement="Create table "+ tabMarketing+" ("
        + "clientMarketingId INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1 MAXVALUE 10000),"
		+ "age INTEGER,"

		+ "sexe STRING,"

        + "taux INTEGER,"

        + "situationFamiliale STRING,"

        + "nbEnfantsAcharge INTEGER,"

        + "2eme voiture STRING,"

		+ "PRIMARY KEY(clientMarketingId))";

		executeDDL(statement);

	}


	/**

		public void executeDDL(String statement)

		méthode générique pour executer les commandes DDL

	*/

	public void executeDDL(String statement) {

		TableAPI tableAPI = store.getTableAPI();

		StatementResult result = null;

		

		System.out.println("****** Dans : executeDDL ********" );

		try {

		/*

		* Add a table to the database.

		* Execute this statement asynchronously.

		*/

		result = store.executeSync(statement);

		displayResult(result, statement);

		} catch (IllegalArgumentException e) {

		System.out.println("Invalid statement:\n" + e.getMessage());

		} catch (FaultException e) {

		System.out.println("Statement couldn't be executed, please retry: " + e);

		}

	}











private void insertAmarketingRow(int age, String sexe, String situationFamiliale, int nbEnfantsAcharge, String 2emeVoiture){

        //TableAPI tableAPI = store.getTableAPI();

        StatementResult result = null;

        String statement = null;

        System.out.println("********************************** Dans : insertAmarketingRow *********************************" );





        try {

            TableAPI tableH = store.getTableAPI();

            // The name you give to getTable() must be identical

            // to the name that you gave the table when you created

            // the table using the CREATE TABLE DDL statement.

            Table marketingTable = tableH.getTable(tabMarketing);

            

            // Get a Row instance

            Row marketingRow = marketingTable.createRow();

            // Now put all of the cells in the row.

            // This does NOT actually write the data to

            // the store.



 



            // Create one row

           
            marketingRow.put("age", age);

            marketingRow.put("sexe", sexe);

            marketingRow.put("taux", taux);

            marketingRow.put("situationFamiliale", situationFamiliale);

            marketingRow.put("nbEnfantsAcharge", nbEnfantsAcharge);

            marketingRow.put("2eme voiture", 2eme voiture);
      


            // Now write the table to the store.

            // "item" is the row's primary key. If we had not set that value,

            // this operation will throw an IllegalArgumentException.

            tableH.put(marketingRow, null, null);



 



        } 

        catch (IllegalArgumentException e) {

            System.out.println("Invalid statement:\n" + e.getMessage());

        } 

        catch (FaultException e) {

            System.out.println("Statement couldn't be executed, please retry: " + e);

        }



 



    }



 



/**

        void loadmarketingDataFromFile(String marketingDataFileName)

        cette methodes permet de charger les marketings depuis le fichier 

        appelé marketing.csv. 

        Pour chaque marketing chargée, la

        méthode insertAmarketingRow sera appélée

    */

    void loadmarketingDataFromFile(String marketingDataFileName){

        InputStreamReader     ipsr;

        BufferedReader         br=null;

        InputStream         ips;

        

        // Variables pour stocker les données lues d'un fichier. 

        String         ligne; 

        System.out.println("********************************** Dans : loadmarketingDataFromFile *********************************" );

        

        /* parcourir les lignes du fichier texte et découper chaque ligne */

        try {

            ips  = new FileInputStream(marketingDataFileName); 

            ipsr = new InputStreamReader(ips); 

            br   = new BufferedReader(ipsr); 

  

            /* open text file to read data */



 



            //parcourir le fichier ligne par ligne et découper chaque ligne en 

            //morceau séparés par le symbole ;  

            while ((ligne = br.readLine()) != null) { 

                //int situationFamiliale, 2eme voiture, nbPortes, prix; 

                //String marketing, age, sexe,  nbEnfantsAcharge,  couleur, occasion, ;



                ArrayList<String> marketingRecord= new ArrayList<String>();    

                StringTokenizer val = new StringTokenizer(ligne,",");

                while(val.hasMoreTokens()) { 

                        marketingRecord.add(val.nextToken().toString()); 

                }

                int age    = marketingRecord.get(0);

                String sexe    = marketingRecord.get(1);

                int taux    = marketingRecord.get(2);

                String situationFamiliale    = marketingRecord.get(3);

                String nbEnfantsAcharge    = marketingRecord.get(4);

                String 2emeVoiture    = Integer.parseInt(marketingRecord.get(5));


                // Add the marketing in the KVStore

                this.insertAmarketingRow(age, sexe, taux, situationFamiliale, nbEnfantsAcharge, 2emeVoiture);

            }

        }

        catch(Exception e){

            e.printStackTrace(); 

        }

    }





	}
