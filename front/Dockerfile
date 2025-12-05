# Stage 1: Préparation des sources
FROM alpine as builder

WORKDIR /tmp/build
COPY index.html .

# Stage 2: Serveur Web Nginx
FROM nginx:stable-alpine

# Création de l'utilisateur système non-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Configuration des permissions pour exécution en non-root
# Création et attribution des droits sur les dossiers critiques de Nginx
RUN mkdir -p /var/cache/nginx/client_temp \
             /var/cache/nginx/proxy_temp \
             /var/cache/nginx/fastcgi_temp \
             /var/cache/nginx/uwsgi_temp \
             /var/cache/nginx/scgi_temp \
             /var/run/nginx \
    && touch /var/run/nginx.pid \
    && chown -R appuser:appgroup /var/cache/nginx \
    && chown -R appuser:appgroup /var/log/nginx \
    && chown -R appuser:appgroup /etc/nginx/conf.d \
    && chown -R appuser:appgroup /var/run/nginx.pid

# Copie des sources web avec les permissions appropriées
COPY --from=builder /tmp/build/index.html /usr/share/nginx/html/index.html
RUN chown -R appuser:appgroup /usr/share/nginx/html

# Exécution en tant qu'utilisateur non-root
USER appuser

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]