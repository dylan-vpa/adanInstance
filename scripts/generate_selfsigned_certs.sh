#!/bin/bash

# Script para generar certificados SSL autofirmados para server.adan.run
# Los certificados se guardarán en las rutas esperadas por el script de configuración Nginx

DOMAIN="server.adan.run"
CERT_DIR="/etc/ssl/certs"
KEY_DIR="/etc/ssl/private"

# Crear directorios si no existen
mkdir -p "$CERT_DIR"
mkdir -p "$KEY_DIR"

# Generar certificado autofirmado
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \\
  -keyout "$KEY_DIR/${DOMAIN}.key" \\
  -out "$CERT_DIR/${DOMAIN}.crt" \\
  -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=$DOMAIN"

echo "Certificado y clave generados en:"
echo "Certificado: $CERT_DIR/${DOMAIN}.crt"
echo "Clave privada: $KEY_DIR/${DOMAIN}.key"
