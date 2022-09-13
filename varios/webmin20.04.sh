# /bin/sh
# variables
// webmin installer Ubuntu 20.04 LTS
//  Run with SUDO, no seas idiota

cat >> /etc/apt/sources.list <<EOF
deb http://download.webmin.com/download/repository sarge contrib
EOF

apt update
wget -q -O- http://www.webmin.com/jcameron-key.asc | sudo apt-key add
apt update
sudo apt install webmin -y