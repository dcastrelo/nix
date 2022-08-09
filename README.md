# scripts para hacer giladas de trabajo

## web servers
install:
apache
php / modulos
mysql

## descargar script de configuracion de apache, sftp
wget -c https://raw.githubusercontent.com/dcastrelo/nix/main/webserver-crear-usuario-scp-vhost.sh

## darle permisos de ejecucion
sudo chmod +x webserver-crear-usuario-scp-vhost.sh

## editar el script y modificar las primeras 3 variables
sudo nano webserver-crear-usuario-scp-vhost.sh

## ejecutar y seguir instrucciones
./webserver-crear-usuario-scp-vhost.sh