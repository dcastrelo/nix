#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Prompt for the new hostname
read -p "Enter the new hostname: " NEW_HOSTNAME

# Validate the hostname
if [[ -z "$NEW_HOSTNAME" ]]; then
    echo "Hostname cannot be empty. Exiting."
    exit 1
fi

# Change the hostname
hostnamectl set-hostname "$NEW_HOSTNAME"

# Update /etc/hosts
sed -i "s/127.0.1.1\s*.*$/127.0.1.1\t$NEW_HOSTNAME/" /etc/hosts

echo "Hostname has been changed to $NEW_HOSTNAME"

# Optional: Restart networking service if necessary
systemctl restart network.service

echo "Hostname change complete. Please reboot or restart networking services to apply changes."