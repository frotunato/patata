#!/bin/bash
 if [ $# -eq 0 ]; then
    echo "No wallet provided"
    rm -- "$0"
    exit 1
fi
 
sudo debconf-set-selections <<< "postfix postfix/mailname string salchipapa.llameante@gmail.com"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get -y install mailutils ssmtp
sudo chmod +x /etc/ssmtp
sudo chmod +x /etc/ssmtp/ssmtp.conf
sudo bash -c 'echo "AuthUser=salchipapa.llameante@gmail.com" >> /etc/ssmtp/ssmtp.conf'
sudo bash -c 'echo "AuthPass=tuculoesmio" >> /etc/ssmtp/ssmtp.conf'
sudo bash -c 'echo "mailhub=smtp.gmail.com:587" >> /etc/ssmtp/ssmtp.conf'
sudo bash -c 'echo "UseSTARTTLS=YES" >> /etc/ssmtp/ssmtp.conf'
sudo chmod +x ./patata/patata
sudo sed -i "20s/.*/\""$1"\"/" ./patata/config.txt
sudo sed -i "18s/.*/\""$2"\"/" ./config.txt
sudo sysctl -w vm.nr_hugepages=128
sudo bash -c 'echo "* soft memlock 262144" >> /etc/security/limits.conf'
sudo bash -c 'echo "* hard memlock 262144" >> /etc/security/limits.conf'
screen -dm sudo ./patata/patata ./patata/config.txt
 
if [ $# -eq 3 ]
  then
    sleep 10    
    echo `ps -C patata -o %cpu,%mem,cmd` | mail --attach=/home/pesetas.log -s "Encendido de $HOSTNAME del proyecto `hostname -d`" $3
fi