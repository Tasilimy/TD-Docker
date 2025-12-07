# Stage 1 : builder
FROM python:3.11 as builder

WORKDIR /app

# Dépendances
COPY api/requirements.txt . 
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2 : image finale
FROM python:3.11-slim

# Utilisateur non-root
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# curl pour healthcheck + clean
RUN apt-get update \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copie des libs installées
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

COPY --chown=appuser:appgroup api/app.py . 

# Exécution non-root
USER appuser

EXPOSE 8080
CMD ["python", "app.py"]