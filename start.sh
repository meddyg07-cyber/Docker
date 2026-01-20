#!/bin/bash

# Start MySQL
service mysql start

# Création base + user
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'user'@'localhost' IDENTIFIED BY 'userpass';
GRANT ALL PRIVILEGES ON wordpress.* TO 'user'@'localhost';
FLUSH PRIVILEGES;
EOF

# Création wp-config si pas existant
if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
  cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
  sed -i "s/database_name_here/wordpress/" /var/www/html/wordpress/wp-config.php
  sed -i "s/username_here/user/" /var/www/html/wordpress/wp-config.php
  sed -i "s/password_here/userpass/" /var/www/html/wordpress/wp-config.php
fi

# Start PHP-FPM
service php7.3-fpm start

# Start Nginx
service nginx start

# Keep container alive
tail -f /dev/null
