#!/bin/bash

# Démarre le service MariaDB en arrière-plan juste le temps de le configurer
service mariadb start

# Petite pause pour laisser le temps à la base de données de bien démarrer
sleep 3

# 1. Création de la base de données (si elle n'existe pas déjà)
mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

# 2. Création de ton utilisateur et attribution d'un mot de passe
mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# 3. On donne tous les droits à cet utilisateur sur la base de données
# Le '%' est crucial : il autorise l'utilisateur à se connecter depuis une autre IP (le conteneur WordPress !)
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# 4. On modifie le mot de passe de l'administrateur suprême (root) pour sécuriser la base
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

# 5. On rafraîchit les droits pour que MariaDB prenne tout en compte immédiatement
mysql -e "FLUSH PRIVILEGES;"

# On éteint proprement le service qu'on avait lancé en arrière-plan
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# On relance MariaDB en "premier plan" (foreground). 
# C'est OBLIGATOIRE pour que le conteneur Docker reste allumé !
exec mysqld_safe