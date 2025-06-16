#!/bin/bash

# Script para instalar Certbot, obtener certificado SSL y configurar Nginx para server.adan.run
# Versión sin sudo para entornos sin permisos de superusuario

DOMAIN="server.adan.run"
EMAIL="hernan.jose.restrepo@outlook.com"  # Cambia esto por tu correo electrónico

# Actualizar paquetes e instalar Certbot y plugin para Nginx
apt update
apt install -y certbot python3-certbot-nginx

# Obtener certificado SSL con Certbot
certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL

# Reiniciar Nginx para aplicar cambios
systemctl restart nginx

echo "Configuración completada. Verifica que Nginx esté corriendo y el certificado SSL esté activo."
echo "Para renovar el certificado automáticamente, Certbot ya configura un cron job."
