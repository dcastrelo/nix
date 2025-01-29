#!/bin/bash

# Script para instalar Certbot, obtener un certificado SSL y configurar la renovación automática

# Verificar si el usuario es root
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse como root. Usa 'sudo' o inicia sesión como root."
  exit 1
fi

# Preguntar por el nombre de dominio
read -p "Ingresa el nombre de dominio para el certificado SSL (ejemplo: midominio.com): " DOMAIN

# Instalar Certbot y el plugin de Apache
echo "Instalando Certbot y el plugin de Apache..."
apt-get install -y certbot python3-certbot-apache

# Crear el certificado SSL para el dominio proporcionado
echo "Creando certificado SSL para $DOMAIN..."
certbot --apache -d "$DOMAIN"

# Configurar la renovación automática del certificado
echo "Configurando la renovación automática del certificado..."
(crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -

# Reiniciar Apache para aplicar los cambios
echo "Reiniciando Apache..."
systemctl restart apache2

# Mostrar mensaje de finalización
echo "Certificado SSL instalado y configurado correctamente."
echo "Accede a tu sitio en: https://$DOMAIN"

exit 0