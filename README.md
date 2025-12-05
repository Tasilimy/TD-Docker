TD - Conception d'Application Conteneurisée

Ce projet consiste à concevoir, conteneuriser et orchestrer une application web complète respectant les principes DevOps modernes.

1. Architecture

L'application repose sur une architecture 3-tiers composée de trois micro-services interconnectés via un réseau privé Docker.

Description des services

Front-end (Service front) :

Technologie : Nginx (image nginx:stable-alpine).

Rôle : Sert les fichiers statiques (HTML/JS) et agit comme Reverse Proxy.

Interaction : Il écoute sur le port 80. Il redirige les appels API (commençant par /items ou /status) vers le service Backend, masquant ainsi la topologie interne au client.

Back-end (Service api) :

Technologie : Python Flask (image python:3.11-slim).

Rôle : API REST traitant la logique métier.

Interaction : Il écoute sur le port 8080 (interne). Il interroge la base de données pour récupérer les données.

Base de Données (Service db) :

Technologie : MySQL 8.0.

Rôle : Persistance des données.

Interaction : Écoute sur le port 3306. Initialisée automatiquement avec un script SQL (init.sql) au premier démarrage.

Schéma des interactions

graph LR
    User((Utilisateur)) -- HTTP :80 --> Nginx[Front Nginx]
    subgraph Réseau Docker
        Nginx -- Proxy :8080 --> API[API Flask]
        API -- SQL :3306 --> DB[(MySQL)]
    end


2. Commandes clés

Voici les commandes principales utilisées pour gérer le cycle de vie de l'application :

Construction des images :

docker compose build --pull


L'option --pull assure d'utiliser les versions les plus récentes et sécurisées des images de base.

Configuration et Vérification :

docker compose config


Permet de valider la syntaxe du fichier docker-compose.yml avant le lancement.

Déploiement (Démarrage) :

docker compose up -d


Lance l'orchestration en arrière-plan (mode détaché).

Vérification de l'état :

docker compose ps


Permet de vérifier que les services sont Up et surtout (healthy).

Arrêt de la stack :

docker compose down


Automatisation :
Un script deploy.sh regroupe toutes ces étapes pour un déploiement en une seule commande :

./deploy.sh


3. Bonnes pratiques suivies

Conformément aux exigences du sujet, nous avons appliqué les pratiques suivantes pour optimiser la sécurité et la performance :

Builds Multi-étapes (Multi-stage builds) :

Utilisation d'une étape intermédiaire builder pour installer les dépendances Python.

L'image finale est copiée depuis le builder, ne conservant que le nécessaire d'exécution, ce qui réduit drastiquement la taille de l'image.

Images légères :

Choix de python:3.11-slim (au lieu de l'image standard) et nginx:alpine pour minimiser l'empreinte disque et la surface d'attaque.

Utilisation de .dockerignore :

Exclusion des fichiers inutiles (__pycache__, .git, .env, logs) du contexte de build pour accélérer la construction et alléger les images.

Sécurité (Utilisateur Non-Root) :

Création d'un utilisateur système dédié appuser dans les Dockerfiles API et Front.

Configuration des permissions spécifiques (notamment pour Nginx sur /var/cache et /var/run) pour permettre l'exécution sans privilèges root.

Supervision (Healthchecks) :

Implémentation de sondes de santé (HEALTHCHECK) dans docker-compose.yml.

Le service Front ne démarre que si l'API est saine, garantissant un démarrage robuste sans erreurs de connexion.

Configuration externalisée :

Aucun mot de passe ou port n'est codé en dur ; tout est géré via le fichier .env.

4. Difficultés rencontrées et améliorations possibles

Difficultés rencontrées

Durant la réalisation du projet, plusieurs obstacles techniques ont été surmontés :

Difficulté

Cause Technique

Solution Apportée

Crash de l'API (Healthcheck)

L'image python:slim est minimale et ne contient pas curl, rendant impossible le test de santé par défaut.

Ajout de l'installation explicite de curl dans le Dockerfile de l'API.

Permissions Nginx (Non-Root)

En exécutant Nginx avec appuser, le processus ne pouvait pas écrire ses logs et fichiers temporaires (Permission denied).

Création préventive des dossiers nécessaires (/var/cache/nginx, etc.) et attribution des droits à appuser dans le Dockerfile.

Encodage des caractères

Les données s'affichaient avec des caractères corrompus (Ã¢) dans l'interface.

Configuration forcée de l'UTF-8 (utf8mb4) dans le connecteur Python et dans la commande de démarrage MySQL (--character-set-server).

Incompatibilité Alpine

Les commandes groupadd (Debian) ne fonctionnent pas sur Alpine Linux (utilisé pour le Front).

Adaptation des commandes pour Alpine : utilisation de addgroup -S et adduser -S.

Améliorations possibles

Pour passer ce projet en production, les pistes suivantes seraient à explorer :

CI/CD (Intégration Continue) : Automatiser le lancement du script deploy.sh et des tests unitaires via un pipeline (GitLab CI ou GitHub Actions) à chaque modification du code.

Sécurisation avancée (HTTPS) : Ajouter un certificat SSL/TLS (via Let's Encrypt) sur le conteneur Nginx pour chiffrer les échanges.

Scaling : Utiliser Docker Swarm ou Kubernetes pour répliquer le service API sur plusieurs conteneurs afin de supporter une charge plus importante.

Registre d'images : Pousser les images construites sur un registre privé (Docker Hub / Harbor) pour que le serveur de production n'ait qu'à les télécharger (pull) sans avoir à les construire.