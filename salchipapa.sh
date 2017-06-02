#!/bin/bash
cd home
sudo rm /etc/cron.d/beacon
sudo debconf-set-selections <<< "postfix postfix/mailname string salchipapa.llameante@gmail.com"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get -y install mailutils ssmtp libmicrohttpd-dev
sudo chmod +x /etc/ssmtp
sudo chmod +x /etc/ssmtp/ssmtp.conf
sudo bash -c 'echo "AuthUser=salchipapa.llameante@gmail.com" >> /etc/ssmtp/ssmtp.conf'
sudo bash -c 'echo "AuthPass=tuculoesmio" >> /etc/ssmtp/ssmtp.conf'
sudo bash -c 'echo "mailhub=smtp.gmail.com:587" >> /etc/ssmtp/ssmtp.conf'
sudo bash -c 'echo "UseSTARTTLS=YES" >> /etc/ssmtp/ssmtp.conf'
sudo chmod +x /patata/patata
sudo sed -i "20s/.*/\""$1"\"/" /patata/config.txt
sudo sed -i "18s/.*/\""$2"\"/" /patata/config.txt
sudo sysctl -w vm.nr_hugepages=128
sudo bash -c 'echo "* soft memlock 262144" >> /etc/security/limits.conf'
sudo bash -c 'echo "* hard memlock 262144" >> /etc/security/limits.conf'
screen -dm sudo /patata/patata /patata/config.txt

if [ $# -eq 3 ]
  then
    sleep 10
    echo `ps -C patata -o %cpu,%mem,cmd` | mail -s "Encendido de $HOSTNAME" "$3"
    echo */2 * * * * `whoami` bash /patata/tramboliko.sh | sudo tee /etc/cron.d/beacon
fi