package org.co2;

import java.util.Arrays;
import java.util.Iterator;
import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.util.GenericOptionsParser;

// Notre classe MAP.
	// Les 4 types generiques correspondent a:
	// 1 - Object: C'est le type de la cle d'entre.
	// 2 - Text: C'est le type de la valeur d'entre.
	// 3 - Text: C'est le type de la cle de sortie.
	// 4 - Text: C'est le type de la valeur de sortie.
	
public class CO2Map extends Mapper<Object, Text, Text, Text> {
	
	// La fonction MAP.
		// Note: Le type du premier argument correspond au premier type generique.
		// Note: Le type du second argument correspond au deuxieme type generique.
		// Note: L'objet Context nous permet d'ecrire les couples (cle, valeur).
		
	protected void map(Object key, Text value, Context context) throws IOException, InterruptedException {

		if (value.toString().contains("Marque")){
			return;
		}

		String node = value.toString(); 
		node = node.replaceAll("\\u00a0"," ");
		
		String[] splitted_node = node.split(","); 
		String eu = "€";
        char euChar = eu.charAt(0);
		String esp = " ";
        char espChar = esp.charAt(0);

		// Gestion colonne marque
		String marque;
		String[] splitted_space = splitted_node[1].split("\\s+"); 
		marque = splitted_space[0]; //creation de la colonne marque

		char c = marque.charAt(0);
		char[] marqueCharArray = marque.toCharArray();
		char[] marqueChar = marque.toCharArray();

		if (c=='"'){
			int a=0;
			for(int i=1;i<marqueCharArray.length;i++){
				marqueChar[a]=marqueCharArray[i];
				a++;
			}
			marque = String.valueOf(marqueChar);
		}

		// Gestion colonne Malus/Bonus
        String malus_bonus;

		if (splitted_node[2].length() == 1){
			malus_bonus="0"; 
		} else {
			malus_bonus = splitted_node[2];
			char[] malus_bonus_char = malus_bonus.toCharArray();
        	char[] malus_bonus_char_parsed = new char[malus_bonus_char.length];

			for(int i=0;i<malus_bonus_char.length;i++){
                if(malus_bonus_char[i] != euChar){
            		malus_bonus_char_parsed[i] += malus_bonus_char[i];
            	}
            	else {
               		break;                	
				}
            }
			malus_bonus = String.valueOf(malus_bonus_char_parsed);

			String[] malus_bonus_splitted = malus_bonus.split(" ");
			malus_bonus = malus_bonus_splitted[0] + malus_bonus_splitted[1];
		}


		// Gestion colonne cout energie
        String cout;
 	    cout = splitted_node[4];
        //cout = splitted_node[4].replaceAll("\\s", "");
        char[] cout_char = cout.toCharArray();
        char[] cout_char_parsed = new char[cout_char.length];
 
        for(int i=0;i<cout_char.length;i++){
            if(cout_char[i] != euChar ){
                cout_char_parsed[i] += cout_char[i];
            }
            else {
				break;
            }
        }
		cout = String.valueOf(cout_char_parsed);
		cout = cout.trim();

		// Gestion colonne Rejet CO2
		String rejet = splitted_node[3];

		// couple clé/valeurs
		String new_value = malus_bonus + "|" +  rejet + "|" + cout;
		
		System.err.print(marque);
		System.err.print("	");
		System.err.println(new_value); 
		

        context.write(new Text(marque), new Text(new_value));
	}
}