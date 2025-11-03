#!/bin/bash

# Wait for MariaDB to be ready
until mysqladmin ping -h"mariadb" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
	echo "Waiting for MariaDB to be ready..."
	sleep 2
done

# Check if WordPress is already installed
if [ ! -f "var/www/html/wp-config.php" ]; then
	echo "WordPress not found. Installing..."

	# Download WordPress core files
	wp core download --path=/var/www/html --allow-root

	# Create wp-config.php
	wp config create	--dbname=${MYSQL_DATABASE} \
						--dbuser=${MYSQL_USER} \
						--dbpass=${MYSQL_PASSWORD} \
						--dbhost=mariadb \
						--path=/var/www/html \
						--allow-root

	# Install WordPress and create admin user
	wp core install	--url=${DOMAIN_NAME} \
					--title="KSINN Inception" \
					--admin_user=${WP_ADMIN_LOGIN} \
					--admin_password=${WP_ADMIN_PASS} \
					--admin_email=${WP_ADMIN_EMAIL} \
					--path=/var/www/html \
					--allow-root

	# Create a standard user
	wp user create ${WP_USER_LOGIN} ${WP_USER_EMAIL} --role=author --user_pass=${WP_USER_PASS} --path=/var/www/html --allow-root

	echo "WordPress installation complete"
else
	echo "WordPress already installed"
fi

# Set correct permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Create the /run/php directory for the PHP-FPM socket"
echo "Creating /run/php directory for PHP-FPM socket..."
mkdir -p /run/php
chown -R www-data:www-data /run/php
chmod 755 /run/php

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec "$@"
