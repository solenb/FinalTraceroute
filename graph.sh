#! /bin/bash

#file=${2:?"Vous devez fournir le nom du fichier .dot en argument."}
nbLignes=$(echo $(wc -l addr.txt)|awk '{print $1}')
echo $nbLignes
if [ -f addr.txt ]; then
	echo "digraph map {" >> map.dot
	for ((i=1; i<=$nbLignes; i+=2)); do
		#saut=$(($i + 1))
		$ip=$(echo $(cat -b addr.txt | sed -n "$i p"))  
		#$ip2=$(echo $(cat -b addr.txt | sed -n "$saut p"))
		echo "$ip1"
	       	#echo "$ip2"
       	done	       


else 
	echo "Aucun fichier contenant les commandes traceroute a été trouvé, veuillez lancer traceroute.sh avant celui-ci."
fi
