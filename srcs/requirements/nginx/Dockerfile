# Base image
FROM debian:bullseye-slim

# Install NGINX and OpenSSL
RUN apt-get update && \
	apt-get install -y nginx openssl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=DE/ST=Baden-Wuerttemberg/L=Heilbronn/O=42/OU=student/CN=ksinn.42.fr"

# Copy the custom NGINX configuration file
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# Expose port 443 for HTTPS traffic
EXPOSE 443

# run NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]
