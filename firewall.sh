#!/bin/bash
# Fail2Ban active FireWall for RGM instance 
# Enumeration directory protection
# SSH brutforce prevention 
# 

#ENVAR
export DIR="/etc/fail2ban/"
export jaildir="/etc/fail2ban/jail.local"

#check if fail2ban's allready installed
if [ -d "$DIR" ]; then
  echo "[*] Fail2Ban's allready installed, Check the script at https://github.com/ArianeBlow/RGM-FireWall/blob/main/firewall.sh to see my rules or post a commit if you have better one !:) "
  exit
  else
    echo "[+] Installing Fail2Ban and putting rules ..."
fi
#install
yum install fail2ban -y

#Directory enumeration Scan pwnage & SSH brut pwnage filters activation
echo "[-] Putting rules"
echo "[DEFAULT]" > $jaildir
echo "# Ban hosts for one hour:" >> $jaildir
echo "bantime = 3600" >> $jaildir
echo "" >> $jaildir
echo "banaction = iptables-multiport" >> $jaildir
echo "" >> $jaildir
echo "[sshd]" >> $jaildir
echo "enabled = true" >> $jaildir
echo "" >> $jaildir
echo "[apache-auth]" >> $jaildir
echo "enabled = true" >> $jaildir
echo "port    = http,https" >> $jaildir
echo "logpath = %(apache_error_log)s" >> $jaildir
echo "" >> $jaildir
echo "[apache-badbots]" >> $jaildir
echo "enabled = true" >> $jaildir
echo "port    = http,https" >> $jaildir
echo "logpath = %(apache_access_log)s" >> $jaildir
echo "bantime = 48h" >> $jaildir
echo "maxretry = 1" >> $jaildir
echo "" >> $jaildir
echo "[apache-noscript]" >> $jaildir
echo "enabled = true" >> $jaildir
echo "port    = http,https" >> $jaildir
echo "logpath = %(apache_error_log)s" >> $jaildir
echo "[+] Rules installed"

# START AND ACTIVE
echo "[-] Staring services"
systemctl enable fail2ban --now
setenforce 0
fail2ban-server start
fail2ban-client reload
service fail2ban restart
echo "[+] Services started"
