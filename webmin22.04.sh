# /bin/sh
# variables
// webmin installer Ubuntu 22.04 LTS
//  Run with SUDO, no seas idiota

cat >> /etc/apt/sources.list <<EOF
deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib
EOF

apt update
curl -fsSL https://download.webmin.com/jcameron-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/webmin.gpg
apt update