# Base image
FROM debian:bullseye-slim

# Install MariaDB server and client
RUN apt-get update && \
	apt-get install -y mariadb-server mariadb-client && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Copy init script
COPY ./tools/init_db.sh /usr/local/bin/init_db.sh
RUN chmod +x /usr/local/bin/init_db.sh

# Expose MariaDB port
EXPOSE 3306

# Set entrypoint for init script
ENTRYPOINT ["/usr/local/bin/init_db.sh"]

# Default command for entrypoint script
CMD ["mariadb"]
