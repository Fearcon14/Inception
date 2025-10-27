#!/bin/bash

# Start MariaDB service in the background
mariadbd --user=mysql --datadir=/var/lib/mysql &
pid="$!"

# Wait for MariaDB to be ready
until mysqladmin ping >/dev/null 2>&1; do
    echo -n "."; sleep 1
done
echo "MariaDB started."

# SQL commands to execute
SQL="
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
CREATE USER IF NOT EXISTS '${WP_ADMIN_USER}'@'%' IDENTIFIED BY '${WP_ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${WP_ADMIN_USER}'@'%' WITH GRANT OPTION;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
"

# Execute the SQL commands
echo "Running initial database setup..."
mysql -u root -e "$SQL"

# Shutdown the temporary server
mysqladmin shutdown
echo "MariaDB setup complete. Waiting for server to shut down..."
wait $pid

# Execute the original CMD from the Dockerfile
echo "Starting MariaDB server..."
exec "$@"
