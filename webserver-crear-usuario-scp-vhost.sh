# /bin/sh
# variables  cheu2Que
# COPIAR CERTIFICADOS EN /etc/apache2/ssl
apt install apache2 -y
NewFolderLock=XXXX
NewUser=XXX
apt install pwgen -y
clear
useradd $NewUser
pwgen
echo Armar una password con alguno de los ejemplos de arriba e ingresarla para el nuevo usuario
passwd $NewUser

echo Se van a crear las carpetas para la pagina web y se le van a dar permisos al usuario

mkdir /var/www/$NewFolderLock
mkdir /var/www/$NewFolderLock/$NewFolderLock
chown root /var/www/$NewFolderLock/$NewFolderLock
chgrp $NewUser /var/www/$NewFolderLock/$NewFolderLock
chmod 775 /var/www/$NewFolderLock/$NewFolderLock
chmod g+s /var/www/$NewFolderLock/$NewFolderLock

#If you have folders that need to be writable by the web server, you can just modify the permission values for the group owner so that www-data has write access. Run this command on each writable folder:
#For security reasons apply this only where necessary and not on the whole website directory.
#chmod g+w /var/www/my-website.com/<writable-folder>

usermod -d /var/www/$NewFolderLock $NewUser
usermod -s /bin/false $NewUser

echo descarga y copia archivos "en mantenimiento"

wget -c https://github.com/dcastrelo/nix/raw/main/files/mantenimiento.tar
tar xvf mantenimiento.tar -C /var/www/html/
tar xvf mantenimiento.tar -C /var/www/$NewFolderLock/$NewFolderLock/
sed -i '/<\/html>/ i <center> $NewFolderLock </center>' /var/www/$NewFolderLock/$NewFolderLock/index.html
sed -i '/<\/html>/ i <center> $NewFolderLock </center>' /var/www/index.html




echo se va a configurar ssh para enjaular al usuario en la carpeta creada anteriormente y solo permitir scp

cat >> /etc/ssh/sshd_config <<EOF
Match User $NewUser
        ChrootDirectory /var/www/$NewFolderLock
        ForceCommand internal-sftp
EOF

echo copiar por SCP certificados *.incaa.gob.ar de webserver en 172.16.0.7 va a pedir clave
scp dario@172.16.0.77:/etc/apache2/ssl/incaaSSL.* /etc/apache2/ssl/

echo se va a crear el vhost
cat > /etc/apache2/sites-available/$NewFolderLock.conf <<EOF

<VirtualHost *:80>
        ServerName $NewFolderLock
        Redirect permanent / https://$NewFolderLock
</VirtualHost>

<VirtualHost *:443>
        ServerName $NewFolderLock
        ServerAdmin redes@incaa.gob.ar

        ErrorLog /var/log/apache2/$NewFolderLock.ssl-error.log
        CustomLog /var/log/apache2/$NewFolderLock.ssl-access.log common
        php_value error_log /var/log/apache2/$NewFolderLock.ssl-php_error.log

        DocumentRoot /var/www/$NewFolderLock/$NewFolderLock

        SSLEngine on
        SSLCertificateFile      /etc/apache2/ssl/incaaSSL.crt
        SSLCertificateKeyFile /etc/apache2/ssl/incaaSSL.key
        SSLCertificateChainFile /etc/apache2/ssl/incaaSSL.ca-bundle

 <Directory /var/www/$NewFolderLock/$NewFolderLock/>
        Options Indexes FollowSymLinks
        AllowOverride all
        Require all granted
 </Directory>
        LogLevel info ssl:warn
</VirtualHost>
EOF

echo se va a habilitar el nuevo vhost y restartear apache
a2ensite $NewFolderLock
a2enmod ssl
service apache2 reload
service apache2 restart

echo Usuario: $NewUser
echo Clave: la que pusimos :P
echo Servidor: $NewFolderLock

echo no te olvides de restartear el equipo y testear los permisos del sftp!
service apache2 reload
service apache2 restart
service sshd reload