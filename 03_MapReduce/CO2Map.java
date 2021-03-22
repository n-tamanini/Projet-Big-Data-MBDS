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
		String node = value.toString(); 
		String[] splitted_node = node.split(","); 

		// Gestion colonne marque
		String marque;
		String[] splitted_space = splitted_node[1].split(""); 
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
		String malus_bonus = splitted_node[2];
		String[] splitted_malus_bonus = malus_bonus.split(""); 
			
		if (splitted_malus_bonus[0]=="-"){
			malus_bonus="0";
		} else {
			malus_bonus = splitted_malus_bonus[0] + splitted_malus_bonus[1];
		}

		// Gestion colonne cout energie
		String cout;
		String[] splitted_cout_energie = splitted_node[4].split(""); 
		cout = splitted_cout_energie[0];

		// Gestion colonne Rejet CO2
		String rejet = splitted_node[3];

		// couple clé/valeurs
		String new_value = malus_bonus + "|" +  rejet + "|" + cout;
        context.write(new Text(marque), new Text(new_value));
	}
}