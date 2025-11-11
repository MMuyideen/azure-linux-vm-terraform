#!/bin/bash

# 1. Install xRDP
 
sudo apt update
sudo apt install xrdp -y

# 2. Install a Desktop Environment (if needed)

sudo apt install xfce4 xfce4-goodies -y
echo "startxfce4" > ~/.xsession


# 3. Restart xRDP
 
sudo systemctl restart xrdp

# 4. Open Port 3389
# If you have a firewall or cloud security group, allow TCP port 3389.
# For cloud platforms (Azure, AWS, etc.), update network security group or firewall rules.
 
# For UFW (Uncomplicated Firewall) on Ubuntu, uncomment the line below:
# sudo ufw allow 3389/tcp

 