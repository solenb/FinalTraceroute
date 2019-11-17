#! /bin/bash
		# Test si argument (adresse) présent
presAddr=${1:?"Vous devez fournir l'adresse à atteindre en argument."}
		# Déclaration de toutes les méthodes à tester (protocole + port)
declare -a meth=("-I" "-U -p 53" "-T -p 443" "-T -p 22" "-T -p 25" "-T -p 80");
compteur=1;
# Début de la boucle traceroute
for compteur in $(seq 1 30); do
	
	for i  in "${meth[@]}"; do

		echo -e "Lancement de la commande suivante : traceroute -A -n -w2 -q1 $i -f $compteur -m $compteur $presAddr"
		# Commande traceroute utilisée 
		tr=$(sudo traceroute -A -n $i -w2 -q1 -f $compteur -m $compteur $presAddr |sed 's/*/#/g' | sed -n "2p")

		# Test si le routeur ne répond pas (affichage d'étoiles)
		if ! [[ $(echo $tr |awk '{print $2}') = "#" ]]; then 
			as=$(echo $tr |awk '{print $3}')	# Récupération du numéro d'AS
			addr=$(echo $tr|awk '{print $2}')	# Récupération de l'adresse IP du routeur au saut actuel
			echo -e "Le routeur répond à la méthode suivante: $i \n $tr"
			break
		elif [[ $i = "-T -p 80" ]]; then
			as="#"
			addr="$compteur"
			echo "Le routeur n°$compteur ne répond pas"
		else
			echo "Le routeur n°$compteur ne répond pas à la méthode $i"		
		fi
	done
	compteur=$(($compteur+1))
	echo $addr $as >> addr.txt	
	if [[ $presAddr == $addr ]]; then
		echo -e "###" >> addr.txt
		break
	fi
	
done

# Enregistrement pour le graph
echo "L'utilitaire Traceroute a atteind avec succès le routeur final 
Voulez-vous donc créer le graphique Xdot ? [y-n]"
read quest
echo $quest
if [[ $(echo $quest) = "y" ]]; then 
	echo $(sudo ./testGraph2.sh )
	echo "Le graphique Xdot a été créé"
	echo $(sudo xdot map.dot)
	echo "Ouverture du fichier Xdot nommé map.dot généré précédemment"
else 
	echo "Le graphique Xdot n'a pas été créé, veuillez lancer le script graph.sh"
fi

