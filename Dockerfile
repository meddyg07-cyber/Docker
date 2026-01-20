FROM debian:buster

# Update + install
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y nginx mariadb-server php php-fpm php-mysql php-cli php-xml php-mbstring wget unzip curl

# Create web folder
RUN mkdir -p /var/www/html /run/php

# Download WordPress
RUN wget https://wordpress.org/latest.zip -P /tmp && \
    unzip /tmp/latest.zip -d /var/www/html/

# Download phpMyAdmin
RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -P /tmp && \
    unzip /tmp/phpMyAdmin-latest-all-languages.zip -d /var/www/html/ && \
    mv /var/www/html/phpMyAdmin-*-all-languages /var/www/html/phpmyadmin

# Copy index menu
COPY index.html /var/www/html/index.html
COPY style.css /var/www/html/style.css

# Copy nginx config
COPY nginx.conf /etc/nginx/sites-available/default

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port
EXPOSE 80

# Exécuter start.sh au démarrage
CMD ["/start.sh"]
