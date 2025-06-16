#!/bin/bash

# Script para instalar Certbot, obtener certificado SSL y configurar Nginx para server.adan.run

DOMAIN="server.adan.run"
EMAIL="ceo@paradixe.xyz"  # Cambia esto por tu correo electrónico

# Actualizar paquetes e instalar Certbot y plugin para Nginx
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

# Obtener certificado SSL con Certbot
sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL

# Reiniciar Nginx para aplicar cambios
sudo systemctl restart nginx

echo "Configuración completada. Verifica que Nginx esté corriendo y el certificado SSL esté activo."
echo "Para renovar el certificado automáticamente, Certbot ya configura un cron job."
