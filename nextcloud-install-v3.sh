#!/bin/bash

# Script para instalar Nextcloud en un servidor Debian/Ubuntu

# Verificar si el usuario es root
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse como root. Usa 'sudo' o inicia sesión como root."
  exit 1
fi

# Preguntar por el nombre de dominio
read -p "Ingresa el nombre de dominio o dirección IP para Nextcloud (ejemplo: nextcloud.midominio.com): " DOMAIN

# Actualizar el sistema
echo "Actualizando el sistema..."
apt update && apt upgrade -y

# Instalar dependencias necesarias (incluyendo unzip)
echo "Instalando dependencias..."
apt install -y apache2 mariadb-server libapache2-mod-php php-gd php-mysql php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-zip php-imagick wget unzip

# Configurar la base de datos MariaDB
echo "Configurando la base de datos MariaDB..."
read -p "Ingresa una contraseña segura para el usuario de la base de datos Nextcloud: " DB_PASSWORD
mysql -u root <<EOF
CREATE DATABASE nextcloud_db;
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON nextcloud_db.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EOF

# Descargar Nextcloud
echo "Descargando Nextcloud..."
NEXTCLOUD_VERSION="26.0.0"  # Cambia a la versión más reciente si es necesario
wget https://download.nextcloud.com/server/releases/nextcloud-$NEXTCLOUD_VERSION.zip -P /tmp

# Extraer Nextcloud
echo "Extrayendo Nextcloud..."
unzip /tmp/nextcloud-$NEXTCLOUD_VERSION.zip -d /var/www/

# Configurar permisos
echo "Configurando permisos..."
chown -R www-data:www-data /var/www/nextcloud
chmod -R 755 /var/www/nextcloud

# Modificar el archivo de configuración de Apache (000-default.conf)
echo "Modificando el archivo de configuración de Apache..."
cat > /etc/apache2/sites-enabled/000-default.conf <<EOF
<VirtualHost *:80>
    DocumentRoot /var/www/nextcloud
    ServerName $DOMAIN

    <Directory /var/www/nextcloud/>
        Options +FollowSymlinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/nextcloud_error.log
    CustomLog \${APACHE_LOG_DIR}/nextcloud_access.log combined
</VirtualHost>
EOF

# Habilitar módulos de Apache
echo "Habilitando módulos de Apache..."
a2enmod rewrite headers env dir mime
systemctl restart apache2

# Finalizar
echo "Instalación completada."
echo "Accede a Nextcloud en: http://$DOMAIN"
echo "Configura Nextcloud en el asistente de instalación web."

exit 0