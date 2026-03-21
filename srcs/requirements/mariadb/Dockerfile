# On part d'une image Debian (Bullseye est très stable pour ça)
FROM debian:bookworm

# On met à jour et on installe MariaDB
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install mariadb-server -y

# On copie notre script de configuration dans le conteneur
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/mariadb.sh /bin/mariadb.sh

# On donne les droits d'exécution au script
RUN chmod +x /bin/mariadb.sh

# On expose le port par défaut de MariaDB (demandé par le sujet)
EXPOSE 3306

# On lance le script au démarrage du conteneur
CMD ["/bin/mariadb.sh"]
