# /bin/sh
# variables  cheu2Que

NewFolderLock=fisca.incaa.gob.ar
NewUser=fisca.incaa
NewSubFolder=fisca.incaa.gob.ar

apt install pwgen -y
clear
useradd $NewUser
pwgen
echo Armar una password con alguno de los ejemplos de arriba e ingresarla para el nuevo usuario
passwd $NewUser
echo Se van a crear las carpetas para la pagina web y se le van a dar permisos al usuario
mkdir /var/www/$NewFolderLock
chown root:$NewUser /var/www/$NewFolderLock
chmod 755 /var/www/$NewFolderLock
mkdir /var/www/$NewFolderLock/$NewSubFolder
chown $NewUser:$NewUser /var/www/$NewFolderLock/$NewSubFolder
chmod 755 /var/www/$NewFolderLock/$NewSubFolder
usermod -d /var/www/$NewFolderLock $NewUser
usermod -s /bin/false $NewUser

echo descarga y copia archivos "en mantenimiento"

wget -c https://github.com/dcastrelo/nix/raw/main/files/mantenimiento.tar
tar xvf mantenimiento.tar -C /var/www/html/
tar xvf mantenimiento.tar -C /var/www/$NewFolderLock/$NewSubFolder/
sed -i '/<\/html>/ i <center> $NewSubFolder </center>' /var/www/$NewFolderLock/$NewSubFolder/index.html
sed -i '/<\/html>/ i <center> $NewSubFolder </center>' /var/www/index.html




echo se va a configurar ssh para enjaular al usuario en la carpeta creada anteriormente y solo permitir scp

cat >> /etc/ssh/sshd_config <<EOF
Match User $NewUser
        ChrootDirectory /var/www/$NewFolderLock
        ForceCommand internal-sftp
EOF

echo copiar por SCP certificados *.incaa.gob.ar de webserver en 172.16.0.7 va a pedir clave
scp dario@172.16.0.77:/etc/apache2/ssl/incaaSSL.* /etc/apache2/ssl/

echo se va a crear el vhost
cat > /etc/apache2/sites-available/$NewSubFolder.conf <<EOF

<VirtualHost *:80>
        ServerName $NewSubFolder
        Redirect permanent / https://$NewSubFolder
</VirtualHost>

<VirtualHost *:443>
        ServerName $NewSubFolder
        ServerAdmin redes@incaa.gob.ar

        ErrorLog /var/log/apache2/$NewSubFolder.ssl-error.log
        CustomLog /var/log/apache2/$NewSubFolder.ssl-access.log common
        php_value error_log /var/log/apache2/$NewSubFolder.ssl-php_error.log

        DocumentRoot /var/www/$NewFolderLock/$NewSubFolder

        SSLEngine on
        SSLCertificateFile      /etc/apache2/ssl/incaaSSL.crt
        SSLCertificateKeyFile /etc/apache2/ssl/incaaSSL.key
        SSLCertificateChainFile /etc/apache2/ssl/incaaSSL.ca-bundle

 <Directory /var/www/$NewFolderLock/$NewSubFolder/>
        Options Indexes FollowSymLinks
        AllowOverride all
        Require all granted
 </Directory>
        LogLevel info ssl:warn
</VirtualHost>
EOF

echo se va a habilitar el nuevo vhost y restartear apache
a2ensite $NewSubFolder
a2enmod ssl
service apache2 reload
service apache2 restart

echo Usuario: $NewUser
echo Clave: la que pusimos :P
echo Servidor: $NewSubFolder

echo no te olvides de restartear el equipo y testear los permisos del sftp!
service apache2 reload
service apache2 restart
service sshd reload