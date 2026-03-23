#!/bin/bash

# Check if the database directory already exists to skip re-configuration
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    
    # Start service temporarily for configuration
    service mariadb start
    sleep 3

    # 1. Create DB and User using environment variables from your .env
    mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"

    # 2. Secure the root user
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -e "FLUSH PRIVILEGES;"

    # 3. Shutdown using the NEW password to allow safe restart
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
else
    echo "Database already initialized. Skipping configuration."
fi

# 4. Final execution in foreground (Required for Docker)
exec mysqld_safe