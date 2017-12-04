#!/bin/bash
if [ ! -f /etc/proof ]; then
    #mkdir /node
    #wget https://nodejs.org/dist/v9.2.0/node-v9.2.0-linux-x64.tar.xz -P /node
    #tar -xpvf /node/node-v9.2.0-linux-x64.tar.xz
    sudo apt-get remove --purge node
    sudo xz -d /patata/node.xz
    sudo chmod +x /patata/node
    sudo mv /patata/node /home
    ln -sf home/node /usr/bin/node
    #sudo curl -sL https://deb.nodesource.com/setup_8.x -o /etc/install_node.sh
    #sudo bash /etc/install_node.sh
    
    #sudo apt-get update && sudo apt-get -y install nodejs
    #sudo apt-get update && sudo apt-get -y install build-essential cmake libuv1-dev nodejs
    sudo bash -c 'echo "* soft memlock 262144" >> /etc/security/limits.conf'
    sudo bash -c 'echo "* hard memlock 262144" >> /etc/security/limits.conf'
    sudo touch /etc/proof
fi
sudo rm /home/patata2
sudo mv /patata/patata2 /home
sudo chmod +x /home/patata2
sudo rm -rf /patata
sudo sysctl -w vm.nr_hugepages=128
screen -dm sudo NODE_ENV=production node /patata/hook.js "$1" "$2"
