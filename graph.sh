#! /bin/bash

#file=${2:?"Vous devez fournir le nom du fichier .dot en argument."}
nbLignes=$(echo $(wc -l addr.txt)|awk '{print $1}')
nblignes=$(($nbLignes*2))
echo $nbLignes
compteur=0
if [ -f addr.txt ]; then
	echo "digraph map {" >> map.dot
	for ((i=1; i<=$nbLignes; i+=2)); do
		saut=$(($i + 1))
		compteur=$(($compteur + 1))
		echo "compteur: $compteur"
		ip1=$(echo $(cat addr.txt | sed -n "$i p"))  
		ip2=$(echo $(cat addr.txt | sed -n "$saut p"))
		cache=$ip2
		echo "cache: $cache"
		if [test `expr $compteur % 2` == 0]; then
			echo "$cache -> $ip2"
			echo b
		else
			echo "$ip1 -> $ip2"
			echo c
		fi
       	done	       


else 
	echo "Aucun fichier contenant les commandes traceroute a été trouvé, veuillez lancer traceroute.sh avant celui-ci."
fi
