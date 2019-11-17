#! /bin/bash
#	Solen BELLOUATI
#	RT2-M3102_Cartographie
#	SCRIPT-Graph
#
#	Ce script a pour but de créer, à partir de l'analyse d'un fichier texte (addr.txt) comportant 
#	les résulats d'une commande Traceroute, un graphique Xdot montrant le chemin parcouru par les paquets IP.
#



echo -n $(rm -rf map.dot)											#Commande permettant de remettre à zéro le précédent fichier Xdot

if [ -f addr.txt ]; then 											#Test de présence du fichier addr.txt
	nbLignes=$(echo $(wc -l addr.txt)|awk '{print $1}') 							#Stockage dans une variable du nombre de lignes présentes dans le fichier addr.txt
	lastLigne=$(echo $(cat -v addr.txt | sed -n "$nbLignes p"))						#Stockage dans une variable de la dernière chaîne de caractère du fichier addr.txt
	echo "digraph map {" >> map.dot
	for i in $(seq 1 $nbLignes); do 									#Boucle permettant d'analyser chaque ligne du fichier addr.txt
		ligne=$(echo $(cat -v addr.txt | sed -n "$i p"))						#Stockage dans une variable de la ligne courante
		next=$(($i + 1))						
		ligneSuivante=$(echo $(cat -v addr.txt | sed -n "$next p"))	
		if [[ $lastLigne == $ligne ]];then 								#Test permettant de savoir si la ligne courante est la dernière
			echo $(sed 's/###//g' addr.txt) 							#Commande permettant de remplacer la chaîne de fin de commande Traceroute par une chaîne vide
			echo -e "\n}" >> map.dot				
		fi
		nbDoublons=$(echo $(cat -n map.dot | grep "}" | wc -l)) 					#Recherche du nombre d'occurence du caractère "}"
		nbSupr=$(($nbDoublons - 1)) 									#Nombre de doublons à supprimer en enlevant le dernier
		if [[ $nbDoublons -ge 2 ]];then									#Test permettant de déterminer si il y a des doublons du caractère "}" 
			for sup in $(seq 1 $nbSupr);do 								#Boucle permettant d'isoler et de supprimer les doublons de "}" se trouvant avant la fin du graphique Xdot
				numLigne=$(echo $(cat -n map.dot | grep "}" | head -n $sup | awk '{print $1}')) #Numéro de la ligne comportant un doublon
				echo $(sed -i "$dataLigne d" map.dot)						#Suppression du doublon	
			done
		fi
		if  [[ ! $ligne == "###" ]] && [[ ! $ligneSuivante == "###" ]];then 				#Test permettant de déterminer si ni la ligne courante ni la suivante n'est la dernière
			echo -e "\n\t \"$ligne\"" "->" >> map.dot 						#Ecriture de la ligne courante dans le fichier map.dot
			echo  -e "\"$ligneSuivante\";" >> map.dot						#Ecriture de la ligne suivante dans le fichier map.dot
		fi
	done       


else 
	echo "Aucun fichier contenant les commandes traceroute a été trouvé, veuillez lancer traceroute.sh avant celui-ci."
fi
