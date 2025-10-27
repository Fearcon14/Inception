# Base image
FROM debian:bullseye-slim

# Install necessary packages
RUN apt-get update && \
	apt-get install -y php7.4-fpm php7.4-mysql curl wget && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Download and install WP-CLI
RUN wget [https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar](https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar) && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# Create web root and WordPress directory
RUN mkdir -p /var/www/html

# Copy the setup script
COPY ./tools/setup_wp.sh /usr/local/bin/setup_wp.sh
RUN chmod +x /usr/local/bin/setup_wp.sh

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Set entrypoint to run the setup script
ENTRYPOINT ["/usr/local/bin/setup_wp.sh"]

# Default command
CMD ["php-fpm7.4", "-F"]
