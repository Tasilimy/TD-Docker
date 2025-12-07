TD - Conception d'une application conteneurisée générique

Ce dépôt contient l'infrastructure Docker complète pour une application 3-Tiers (Front Nginx, API Flask, DB MySQL).

Prérequis : 

Pour lancer ce projet, vous devez disposer de :

Docker et Docker Compose installés sur la machine.

Git pour cloner le dépôt.

Installation et démarrage : 

Suivez ces étapes pour déployer l'application en quelques secondes.

1. Cloner le projet

git clone https://github.com/Tasilimy/TD_Docker-SYSOPS-C2-KABA-Tasilimy.git
cd TD_Docker-SYSOPS-C2-KABA-Tasilimy

2. Configuration des Secrets (.env)

Par sécurité, le fichier de configuration n'est pas versionné. Vous devez le créer à la racine :

Créez le fichier :

touch .env

Ajoutez-y le contenu suivant (configuration par défaut) : 

API_PORT=8080
MYSQL_ROOT_PASSWORD=TPdocker2025
MYSQL_DATABASE=appdb
MYSQL_USER=appuser
MYSQL_PASSWORD=appppassword
DB_HOST=db
DB_PORT=3306


3. Lancement Automatisé

Un script de déploiement est fourni pour automatiser le build et le lancement :

# Lancez le déploiement
./deploy.sh


(Alternative manuelle : docker compose up --build -d)

Vérifications :

Une fois le script terminé, l'application est accessible :

Interface Web affichant la liste des items : http://localhost/ 

API (via Proxy) : http://localhost/status (Doit répondre {"status": "OK"})

Données (DB) : http://localhost/items (Doit afficher la liste des données injectées)

Pour plus d'informations se réferer au fichier .pdf : [Rapport_TD-Docker-SYSOPS-C2-KABA-Tasilimy.pdf]

Auteur : KABA Tasilimy - EPSI Bachelor SYSOPS