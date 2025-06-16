#!/bin/bash

# Script para configurar Nginx con SSL manualmente sin usar Certbot
# Debes tener ya los certificados SSL (privado y público) generados y ubicados en las rutas indicadas

DOMAIN="server.adan.run"

# Rutas a los certificados SSL (cambia estas rutas por las correctas)
SSL_CERT="/etc/ssl/certs/${DOMAIN}.crt"
SSL_KEY="/etc/ssl/private/${DOMAIN}.key"

if [ ! -f "$SSL_CERT" ] || [ ! -f "$SSL_KEY" ]; then
  echo "No se encontraron los certificados SSL en las rutas especificadas."
  echo "Por favor, genera o copia los certificados en:"
  echo "Certificado: $SSL_CERT"
  echo "Clave privada: $SSL_KEY"
  exit 1
fi

# Crear archivo de configuración Nginx para el dominio con SSL
NGINX_CONF="/etc/nginx/sites-available/${DOMAIN}.conf"

cat > "$NGINX_CONF" <<EOL
server {
    listen 80;
    server_name $DOMAIN;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN;

    ssl_certificate $SSL_CERT;
    ssl_certificate_key $SSL_KEY;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        return 200 'Hola Mundo desde Nginx!';
        add_header Content-Type text/plain;
    }

    location /v1/completions {
        proxy_pass http://localhost:8000/v1/completions;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

# Habilitar configuración y reiniciar Nginx
ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/

echo "Configuración Nginx creada en $NGINX_CONF"
echo "Por favor, reinicia Nginx manualmente para aplicar los cambios:"
echo "service nginx restart"
