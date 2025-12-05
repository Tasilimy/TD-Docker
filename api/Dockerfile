# Stage 1: Builder
FROM python:3.11-slim as builder

WORKDIR /app

# Installation des dépendances
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Production image
FROM python:3.11-slim

# Création de l'utilisateur non-root
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Installation de curl pour le healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Récupération des dépendances depuis le builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

# Copie du code source avec les bonnes permissions
COPY --chown=appuser:appgroup app.py .

# Exécution en tant qu'utilisateur non-root
USER appuser

EXPOSE 8080
CMD ["python", "app.py"]