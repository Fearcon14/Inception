#!/bin/bash

# Create the runtime directory for the MariaDB socket
echo "Creating /run/mysqld and setting permissions..."
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

# Start MariaDB service in the background
mariadbd --user=mysql --datadir=/var/lib/mysql --skip-grant-tables &
pid="$!"

# Wait for MariaDB to be ready
until mysqladmin -h 127.0.0.1 ping >/dev/null 2>&1; do
    echo -n "."; sleep 1
done
echo "MariaDB started."

# SQL commands to execute
SQL="
FLUSH PRIVILEGES;
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
mysql -h 127.0.0.1 -u root -e "$SQL"

# Shutdown the temporary server
echo "MariaDB setup complete. Shutting down temporary server..."
mysqladmin -h 127.0.0.1 -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait $pid

# The temporary server's shutdown might have removed the /run/mysqld directory.
echo "Re-creating /run/mysqld for permanent server..."
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

# Do not use 'exec "$@"'. We must explicitly start the server as the 'mysql' user
# because that user now owns the data files in /var/lib/mysql.
echo "Starting MariaDB server as 'mysql' user..."
exec mariadbd --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0