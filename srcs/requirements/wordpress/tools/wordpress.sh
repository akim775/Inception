#!/bin/bash

# On se place dans le dossier qui contient le site (lié à ton volume)
cd /var/www/wordpress

# On vérifie si WordPress est déjà installé (pour ne pas tout écraser si on redémarre le conteneur)
if [ ! -f wp-config.php ]; then
    echo "WordPress n'est pas installé. Installation en cours..."

    # 1. On télécharge les fichiers sources de WordPress
    wp core download --allow-root

    # 2. On crée le fichier wp-config.php pour lier WordPress à MariaDB
    # On utilise le nom de conteneur "mariadb" comme adresse hôte (dbhost)
    wp config create --dbname=${MYSQL_DATABASE} \
                     --dbuser=${MYSQL_USER} \
                     --dbpass=${MYSQL_PASSWORD} \
                     --dbhost=mariadb:3306 \
                     --allow-root

    # 3. On installe le site et on crée le compte Administrateur
    wp core install --url=${DOMAIN_NAME} \
                    --title="Inception 42" \
                    --admin_user=${WP_ADMIN_USER} \
                    --admin_password=${WP_ADMIN_PASSWORD} \
                    --admin_email=admin@42.fr \
                    --allow-root

    # 4. On crée le 2ème utilisateur classique (Auteur) exigé par le sujet
    wp user create ${WP_USER} user@42.fr \
                   --role=author \
                   --user_pass=${WP_USER_PASSWORD} \
                   --allow-root

    echo "Installation de WordPress terminée avec succès !"
else
    echo "WordPress est déjà installé et configuré."
fi

# 5. Règle d'or de Docker : on lance PHP-FPM au premier plan (-F) pour garder le conteneur en vie
exec /usr/sbin/php-fpm8.2 -F