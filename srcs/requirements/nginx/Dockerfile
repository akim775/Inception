FROM debian:bookworm

# Installation de NGINX et OpenSSL
RUN apt update -y && apt upgrade -y && \
    apt install nginx openssl -y

# Création du dossier pour le certificat SSL
RUN mkdir -p /etc/nginx/ssl

# Génération du certificat auto-signé (Remplace 'ahamini' par ton login !)
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=ahamini.42.fr/UID=ahamini"

# Création du dossier pour les fichiers du site
RUN mkdir -p /var/run/nginx

# Copie de ta configuration NGINX personnalisée
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Le conteneur écoutera sur le port 443
EXPOSE 443

# Lancement de NGINX en premier plan (daemon off) pour que le conteneur ne se coupe pas
CMD [ "nginx", "-g", "daemon off;" ]