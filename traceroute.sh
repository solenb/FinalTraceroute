#! /bin/bash
#	Solen BELLOUATI
#	RT2-M3102_Cartographie
#	SCRIPT-Traceroute
#	
#	Ce script a pour but de créer et remplir un fichier (addr.txt) avec les différents sauts  
#	que la commande traceroute aura récupéré.
#	Ce script peut en fonction de la réponse ou non d'un saut à une méthode en choisir une autre.
#	Il automatise la création du graphique Xdot en demandant à la fin à l'utilisateur si il 
#	souhaite créer le graphique Xdot.
#


presAddr=${1:?"Vous devez fournir l'adresse à atteindre en argument."} 								#Test de présence de l'argument (adresse IPV4)
declare -a meth=("-I" "-U -p 53" "-T -p 443" "-T -p 22" "-T -p 25" "-T -p 80");							#Déclaration de toutes les méthodes à tester associant protocole réseau et port applicatif
compteur=1;



for compteur in $(seq 1 30); do													#Initialisation de la boucle principale permettant d'incrémenter le TTL du paquet IP
	
	for i  in "${meth[@]}"; do												#Initialisation de la boucle permettant de tester différentes méthode en fonction de la réponse du routeur 

		echo -e "Lancement de la commande suivante : traceroute -A -n -w2 -q1 $i -f $compteur -m $compteur $presAddr"	
		tr=$(sudo traceroute -A -n $i -w2 -q1 -f $compteur -m $compteur $presAddr |sed 's/*/#/g' | sed -n "2p")		#Commande traceroute, avec un remplactement en sortie des étoiles par des #, et récupération unique de la 2eme ligne

		
		if ! [[ $(echo $tr |awk '{print $2}') = "#" ]]; then 								#Test permettant de savoir si le routeur répond à la requête
			as=$(echo $tr |awk '{print $3}')									#Stockage du numéro d'AS dans une variable
			addr=$(echo $tr|awk '{print $2}')									#Stockage de l'adresse IP du routeur au saut actuel dans une variable
			echo -e "Le routeur répond à la méthode suivante: $i \n $tr"						
			break
		elif [[ $i = "-T -p 80" ]]; then										#Test permettant de savoir si la méthode courante est la dernière
			as="#"													#Le routeur ne transmet pas le numéro d'AS donc on place un #
			addr="$compteur"											#L'adresse IPV4 est remplacée par le numéro de saut actuel
			echo "Le routeur n°$compteur ne répond pas"
		else
			echo "Le routeur n°$compteur ne répond pas à la méthode $i"		
		fi
	done
	compteur=$(($compteur+1))												#On incrémente le numéro de saut
	echo $addr $as >> addr.txt												#On injecte dans le fichier addr.txt l'adresse IPV4 suivie du numéro d'AS
	if [[ $presAddr == $addr ]]; then											#On test si l'adresse actuelle est bien celle à atteindre (fin des boucles)
		echo -e "###" >> addr.txt											#On injecte ### à la fin du fichier addr.txt pour spécifier la fin de la commande actuelle
		break
	fi
	
done


echo "L'utilitaire Traceroute a atteind avec succès le routeur final								 
Voulez-vous donc créer le graphique Xdot ? [y-n]"										#Demande à l'utilisateur si celui veut créer automatiquement le graphique Xdot
read quest															#Stockage de la réponse de l'utilisateur dans la variable quest
if [[ $(echo $quest) = "y" ]]; then 												#Test permettant de savoir si l'utilisateur veut créer le graphique
	echo $(sudo ./graph.sh)													#Lancement du script de création du graph												
	echo "Le graphique Xdot a été créé"
	echo $(sudo xdot map.dot)												#Commande permettant de créer le graphique grâce à Xdot
	echo "Ouverture du fichier Xdot nommé map.dot généré précédemment"
else 
	echo "Le graphique Xdot n'a pas été créé, veuillez lancer le script graph.sh"
fi

