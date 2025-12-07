#!/bin/bash
# ------------------------------------------------------------------
# Script de déploiement automatisé (CI/CD Local)
#
# Description :
#   Ce script orchestre le cycle de vie complet de l'application :
#   1. Nettoyage de l'environnement existant.
#   2. Validation de la configuration Docker.
#   3. Construction des images avec optimisation (pull des bases).
#   4. Simulation des étapes de sécurité (Scan/Push/Sign).
#   5. Déploiement des conteneurs et vérification de santé.
#
# Usage :
#   ./deploy.sh
#
# Prérequis :
#   - Docker Engine & Docker Compose installés.
#   - Accès internet pour le pull des images de base.
# ------------------------------------------------------------------

# Configuration du registre (à modifier pour la production)
REGISTRY_USER="mon_user_docker"
VERSION="1.0"

# Fonction de log pour standardiser la sortie
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2
}

log_success() {
    echo "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# --- Étape 1 : Initialisation ---
log_info "Démarrage de la procédure de déploiement..."
log_info "Nettoyage des conteneurs et réseaux existants..."
docker compose down --remove-orphans

# --- Étape 2 : Validation ---
log_info "Validation de la syntaxe du fichier docker-compose.yml..."
docker compose config > /dev/null
if [ $? -ne 0 ]; then
    log_error "La configuration Docker Compose est invalide. Arrêt du déploiement."
    exit 1
fi
log_info "Configuration validée avec succès."

# --- Étape 3 : Construction (Build) ---
log_info "Lancement du build des images (API & Front)..."
# L'option --pull garantit l'utilisation des dernières versions sécurisées des images de base (Alpine/Python Slim)
docker compose build --pull
if [ $? -ne 0 ]; then
    log_error "Échec lors de la compilation des images Docker."
    exit 1
fi

# --- Étape 4 : Sécurité & Distribution (Simulation) ---
log_info "Exécution des contrôles de sécurité et push vers le registre..."

# Note technique : Les étapes suivantes sont désactivées en local.
# Configurer DOCKER_CONTENT_TRUST=1 et 'docker login' pour la production.

# 1. Analyse statique des vulnérabilités (ex: Snyk, Trivy)
# docker scan ${REGISTRY_USER}/td-api:${VERSION}

# 2. Signature et Push (Docker Content Trust)
# export DOCKER_CONTENT_TRUST=1
# docker login
# docker push ${REGISTRY_USER}/td-api:${VERSION}
# docker push ${REGISTRY_USER}/td-front:${VERSION}
# export DOCKER_CONTENT_TRUST=0

log_info "Étapes de sécurité et de distribution ignorées (Mode Local)."

# --- Étape 5 : Déploiement (Run) ---
log_info "Déploiement de la stack applicative..."
docker compose up -d

log_info "Attente de l'initialisation des services (Healthchecks)..."
sleep 10

# Vérification finale
if docker compose ps | grep -q "healthy"; then
    log_success "Déploiement terminé avec succès."
    docker compose ps
    echo ""
    echo "---------------------------------------------------"
    echo " Application accessible sur : http://localhost:80"
    echo "---------------------------------------------------"
else
    log_error "Certains services ne semblent pas sains. Vérifiez les logs avec 'docker compose logs'."
    docker compose ps
    exit 1
fi