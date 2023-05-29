# /bin/sh
scp -r dario@172.16.0.15:/home/dario/ssl /home/dario/ssl23
sudo cp /home/dario/ssl23/incaaSSL.ca-bundle /etc/apache2/ssl
sudo cp /home/dario/ssl23/incaaSSL.crt /etc/apache2/ssl
sudo cp /home/dario/ssl23/incaaSSL.key /etc/apache2/ssl
sudo nano /etc/apache2/sites-enabled/*.conf
sudo service apache2 restart