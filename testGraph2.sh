#! /bin/bash

#file=${2:?"Vous devez fournir le nom du fichier .dot en argument."}
echo -n $(rm -rf map.dot) #permet de remettre à zéro le fichier Xdot
nbLignes=$(echo $(wc -l addr.txt)|awk '{print $1}') #permet de compter le nombre de lignes du fichier addr.txt
echo $nbLignes
lastLigne=$(echo $(cat -v addr.txt | sed -n "$nbLignes p"))
echo "last:$lastLigne!!"
if [ -f addr.txt ]; then 
	echo "digraph map {" >> map.dot
	for i in $(seq 1 $nbLignes); do
		ligne=$(echo $(cat -v addr.txt | sed -n "$i p"))
		echo $ligne
		next=$(($i + 1))
		ligneSuivante=$(echo $(cat -v addr.txt | sed -n "$next p"))
		if [[ $lastLigne == $ligne ]];then
			echo $(sed 's/###//g' addr.txt) 	
			echo -e "\n}" >> map.dot
		fi
		nbDoublons=$(echo $(cat -n map.dot | grep "}" | wc -l))
		nbSupr=$(($nbDoublons - 1))
		if [[ $nbDoublons -ge 2 ]];then
			for sup in $(seq 1 $nbSupr);do
				echo "à sup $sup"
			done
		fi
		if  [[ ! $ligne == "###" ]] && [[ ! $ligneSuivante == "###" ]];then	
			echo -e "\n\t \"$ligne\"" "->" >> map.dot 
			echo  -e "\"$ligneSuivante\";" >> map.dot
		fi
	done       


else 
	echo "Aucun fichier contenant les commandes traceroute a été trouvé, veuillez lancer traceroute.sh avant celui-ci."
fi
