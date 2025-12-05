🐳 TD - Application Conteneurisée (Docker)

Étudiant : [Ton Nom]

Module : Administration Systèmes et Réseaux

Sujet : Conception, orchestration et déploiement d'une application 3-tiers sécurisée.

📑 Table des Matières

Architecture Technique

Guide de Démarrage

Choix Techniques & Sécurité

Difficultés & Solutions

1. Architecture Technique

L'application repose sur une architecture micro-services isolée dans un réseau privé Docker.

🧩 Schéma d'Architecture

graph LR
    subgraph "Monde Extérieur"
        Client((Utilisateur))
    end

    subgraph "Hôte Docker"
        direction TB
        Client -- "HTTP :80" --> Front[🖥️ Front Nginx]
        
        subgraph "Réseau Privé (Bridge)"
            Front -- "Proxy Pass :8080" --> API[⚙️ API Flask]
            API -- "TCP :3306" --> DB[(🗄️ MySQL)]
        end
    end

    style Front fill:#009639,stroke:#333,stroke-width:2px,color:white
    style API fill:#3776AB,stroke:#333,stroke-width:2px,color:white
    style DB fill:#4479A1,stroke:#333,stroke-width:2px,color:white


📦 Description des Services

Service

Image Docker

Rôle & Configuration

Front-end

nginx:stable-alpine

Reverse Proxy & Serveur statique. 



• Écoute sur le port 80. 



• Redirige /items vers l'API.

Back-end

python:3.11-slim

API REST (Flask). 



• Expose les données JSON. 



• Écoute sur le port 8080 (interne uniquement).

Base de Données

mysql:8.0

Persistance. 



• Données stockées dans le volume db-data. 



• Initialisation auto via init.sql.

2. Guide de Démarrage

✅ Prérequis

Docker Desktop installé.

Git installé.

🚀 Déploiement Automatisé

Un script Bash interactif est fourni pour valider, construire et lancer la stack en une commande :

./deploy.sh


🛠️ Commandes Manuelles

Action

Commande

Construction

docker compose build --pull

Lancement

docker compose up -d

Statut

docker compose ps

Arrêt

docker compose down

3. Choix Techniques & Sécurité

Pour répondre aux exigences de production, plusieurs bonnes pratiques DevOps ont été implémentées :

🔒 Sécurité Renforcée

Utilisateur Non-Root : Création d'un utilisateur système (appuser) dans les Dockerfiles. Aucun conteneur applicatif ne tourne en root.

Permissions Nginx : Configuration fine des droits sur /var/cache et /var/run pour permettre l'exécution sécurisée.

Isolation Réseau : La base de données n'est pas exposée publiquement, seul l'API peut lui parler.

⚡ Performance & Optimisation

Multi-Stage Builds : Utilisation d'une étape builder temporaire pour installer les dépendances Python, réduisant la taille finale de l'image.

Images Minimales : Utilisation des versions alpine et slim (ex: python:3.11-slim pèse ~150Mo contre ~900Mo pour l'image standard).

.dockerignore : Exclusion des fichiers inutiles (__pycache__, .git) pour accélérer le build.

4. Difficultés & Solutions

Voici un résumé des défis techniques rencontrés lors de la réalisation du TD :

Problème Rencontré

Analyse

Solution Apportée

❌ Crash Healthcheck API

L'image python:slim est trop légère, elle ne contient pas curl.

Ajout de apt-get install curl dans le Dockerfile API.

❌ Erreur "Permission Denied"

Nginx (en user non-root) ne pouvait pas écrire ses logs au démarrage.

Création préventive des dossiers (/var/cache/nginx) avec chown appuser dans le Dockerfile.

❌ Accents corrompus (Ã¢)

Encodage par défaut de MySQL ou du connecteur Python incorrect.

Ajout de charset='utf8mb4' dans Python et --character-set-server dans Docker Compose.

❌ Erreur Build Alpine

La commande groupadd n'existe pas sous Alpine Linux.

Utilisation des équivalents Alpine : addgroup -S et adduser -S.

🔮 Améliorations Futures

[ ] Mise en place de HTTPS avec Let's Encrypt.

[ ] Intégration du script dans une pipeline CI/CD (GitHub Actions).

[ ] Hébergement des images sur un Registre Privé (Docker Hub) pour accélérer le déploiement.