# /bin/sh
NewFolderLock=castrelo
NewUser=wdcar

mkdir /var/www/$NewFolderLock/$NewFolderLock
chown root /var/www/castrelo.com.ar/castrelo.com.ar
chgrp $NewUser /var/www/castrelo.com.ar/castrelo.com.ar
chmod 775 /var/www/castrelo.com.ar/castrelo.com.ar
chmod g+s /var/www/castrelo.com.ar/castrelo.com.ar