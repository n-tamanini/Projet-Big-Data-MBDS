package ...;

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


// Classe Driver (contient le main du programme Hadoop).
public class CO2 {

		

// Notre classe MAP.
	// Les 4 types generiques correspondent a:
	// 1 - Object: C'est le type de la cle d'entre.
	// 2 - Text: C'est le type de la valeur d'entre.
	// 3 - Text: C'est le type de la cle de sortie.
	// 4 - Text: C'est le type de la valeur de sortie.
	
	public static class CO2Map extends Mapper<Object, Text, Text, Text> {
	
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
				for(i=1;i<length.marqueCharArray;i++){
					marqueChar[a]=marqueCharArray[i];
					a++;
				}
				marque = String.valueOf(marqueChar);
				
			}


			// Gestion colonne Malus/Bonus
			String[] splitted_malus_bonus = splitted_node[3].split(""); 
			String malus_bonus = splitted_node[3];

			malus_bonus = splitted_malus_bonus[0] + splitted_malus_bonus[1];
			if (splitted_malus_bonus[0]=="-"){
				malus_bonus="0";
			}
			
			// Gestion colonne cout energie
			String cout;
			String[] splitted_cout_energie = splitted_node[5].split(""); 
			cout = splitted_cout_energie[0];

			// Gestion colonne Rejet CO2
			String rejet = splitted_node[4];


			// couple clé/valeurs
			 String new_value = malus_bonus + "|" +  rejet + "|" + cout;
            context.write(marque, new Text(new_value));

		}
	
	
	// Notre classe REDUCE.
	// Les 4 types generques correspondent a:
	// 1 - Text: C'est le type de la cle d'entre.
	// 2 - Text: C'est le type de la valeur d'entre.
	// 3 - Text: C'est le type de la cle de sortie.
	// 4 - Text: C'est le type de la valeur de sortie.
	
	
	// Notre classe REDUCE.
	// Les 4 types generques correspondent a:
	// 1 - Text: C'est le type de la cle d'entre.
	// 2 - Text: C'est le type de la valeur d'entre.
	// 3 - Text: C'est le type de la cle de sortie.
	// 4 - Text: C'est le type de la valeur de sortie.
	public static class CO2Reduce extends Reducer<Text, Text, Text, Text> {
		// La fonction REDUCE.
		// Les arguments:
		//   La cle key,
		//   Un Iterable de toutes les valeurs qui sont associees a la cle en question
		//   Le contexte Hadoop (un handle qui nous permet de renvoyer le resultat a Hadoop).
		// Note: Le type du premier argument correspond au premier type generique.
		// Note: Le type du second argument Iterable correspond au deuxieme type generique.
		// Note: L'objet Context nous permet d'ecrire les couples (cle,valeur).
		public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
			// Pour parcourir toutes les valeurs associées a la cle fournie.
			// key = la cle (ex. "aekl")
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
				String[] splitted_node = node.split("|"); 
				
				malus_bonus = splitted_node[0];
				rejet = splitted_node[1];
				cout = splitted_node[2];

				sommeBonus_Malus = Integer.parseInt(malus_bonus);
				sommeRejet = Integer.parseInt(rejet);
				sommeCout = Integer.parseInt(cout);

				sommeBonus_Malus+=malus_bonus;
				sommeRejet+=rejet;
				sommeCout+=cout;

				count++;


		}
		moyenneMalus_Bonus = sommeBonus_Malus/count;
		moyenneRejet = sommeRejet/count;
		moyenneCout = sommeCout/count;

		context.write(key, new Text(moyenneMalus_Bonus + "|" + moyenneRejet + "|" + moyenneCout));
}


// Le main du programme.
	public static void main(String[] args) throws Exception {
	
		// Cree un object de configuration Hadoop.
		Configuration conf = new Configuration();
		// Permet a Hadoop de lire ses arguments generiques, recupere les arguments restants dans ourArgs.
		String[] ourArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
		// Obtient un nouvel objet Job: une tache Hadoop. On fourni la configuration Hadoop ainsi qu'une description
		// textuelle de la tache.
		Job job = Job.getInstance(conf, "CO2 MapReduce");

		// Defini les classes driver, map et reduce.
		job.setJarByClass(CO2.class);
		job.setMapperClass(CO2Map.class);
		job.setReducerClass(CO2Reduce.class);

		// Defini types cle/valeurs de notre programme Hadoop.
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(Text.class);
	
		// Defini les fichiers d'entree du programme et le repertoire des resultats.
		// On se sert du premier et du deuxieme argument restants pour permettre a l'utilisateur de les specifier
		// lors de l'execution.
		FileInputFormat.addInputPath(job, new Path(ourArgs[0]));
		FileOutputFormat.setOutputPath(job, new Path(ourArgs[1]));

		// On lance la tache Hadoop. Si elle s'est effectuee correctement, on renvoie 0. Sinon, on renvoie -1.
		if(job.waitForCompletion(true))
			System.exit(0);
		System.exit(-1);
		}
	
	}























