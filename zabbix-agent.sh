# /bin/sh
# variables
##  Run with SUDO, no seas idiota
wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bubuntu22.04_all.deb
dpkg -i zabbix-release_6.2-4+ubuntu22.04_all.deb
apt update
apt install zabbix-agent2 zabbix-agent2-plugin-*
systemctl restart zabbix-agent2
systemctl enable zabbix-agent2