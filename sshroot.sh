#!/bin/bash

# Script para permitir el login de root por SSH en Debian/Ubuntu

# Verificar si el usuario es root
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse como root. Usa 'sudo' o inicia sesión como root."
  exit 1
fi

# Archivo de configuración de SSH
SSH_CONFIG="/etc/ssh/sshd_config"

# Respaldar el archivo de configuración original
BACKUP_FILE="/etc/ssh/sshd_config.backup"
if [ ! -f "$BACKUP_FILE" ]; then
  cp "$SSH_CONFIG" "$BACKUP_FILE"
  echo "Se ha creado una copia de seguridad del archivo de configuración en $BACKUP_FILE."
fi

# Modificar la configuración de SSH para permitir el acceso root
echo "Modificando la configuración de SSH..."
sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' "$SSH_CONFIG"
sed -i 's/^PermitRootLogin no/PermitRootLogin yes/' "$SSH_CONFIG"

# Reiniciar el servicio SSH
echo "Reiniciando el servicio SSH..."
systemctl restart ssh

# Verificar el estado del servicio SSH
SSH_STATUS=$(systemctl is-active ssh)
if [ "$SSH_STATUS" == "active" ]; then
  echo "El servicio SSH se ha reiniciado correctamente."
else
  echo "Hubo un problema al reiniciar el servicio SSH. Verifica el estado manualmente."
  exit 1
fi

# Mostrar mensaje de éxito
echo "El acceso SSH para el usuario root ha sido habilitado correctamente."
echo "Puedes probar conectándote como root usando: ssh root@<IP_DEL_SERVIDOR>"

exit 0