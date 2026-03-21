FROM debian:bookworm

# Installation de PHP 8.2
RUN apt update -y && apt upgrade -y && \
    apt install wget php8.2 php8.2-fpm php8.2-mysql mariadb-client -y

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Attention au nouveau chemin pour PHP 8.2 !
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/wordpress.sh /bin/wordpress.sh
RUN chmod +x /bin/wordpress.sh

EXPOSE 9000
CMD ["/bin/wordpress.sh"]