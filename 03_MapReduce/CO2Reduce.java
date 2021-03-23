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
    
    // Notre classe REDUCE.
	// Les 4 types generques correspondent a:
	// 1 - Text: C'est le type de la cle d'entre.
	// 2 - Text: C'est le type de la valeur d'entre.
	// 3 - Text: C'est le type de la cle de sortie.
	// 4 - Text: C'est le type de la valeur de sortie.
	
public class CO2Reduce extends Reducer<Text, Text, Text, Text> {
	// La fonction REDUCE.
	// Les arguments:
	//   La cle key,
	//   Un Iterable de toutes les valeurs qui sont associees a la cle en question
	//   Le contexte Hadoop (un handle qui nous permet de renvoyer le resultat a Hadoop).
	// Note: Le type du premier argument correspond au premier type generique.
	// Note: Le type du second argument Iterable correspond au deuxieme type generique.
	// Note: L'objet Context nous permet d'ecrire les couples (cle,valeur).
	public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
		String malus_bonus = "";
		String rejet = "";
		String cout = "";
		int sommeBonus_Malus = 0;
		int sommeRejet = 0;
		int sommeCout = 0;
		int count=0;
		int moyenneMalus_Bonus;
		int moyenneRejet;
		int moyenneCout;
			
		Iterator<Text> i = values.iterator();
		while(i.hasNext()) {
			String node = i.next().toString(); 
			String[] splitted_node = node.split("\\|"); 
				
			malus_bonus = splitted_node[0];
			rejet = splitted_node[1];
			cout = splitted_node[2];

			sommeBonus_Malus = Integer.parseInt(malus_bonus);
			sommeRejet = Integer.parseInt(rejet);
			sommeCout = Integer.parseInt(cout);

			sommeBonus_Malus+=sommeBonus_Malus;
			sommeRejet+=sommeRejet;
			sommeCout+=sommeCout;

			count++;
		}

		moyenneMalus_Bonus = sommeBonus_Malus/count;
		moyenneRejet = sommeRejet/count;
		moyenneCout = sommeCout/count;

		context.write(key, new Text(moyenneMalus_Bonus + "|" + moyenneRejet + "|" + moyenneCout));
	}
}