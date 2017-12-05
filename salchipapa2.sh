#!/bin/bash
if [ ! -f /etc/proof2 ]; then
    sudo apt-get remove --purge node
    sudo xz -d /patata/node.xz
    sudo chmod +x /patata/node
    sudo mv /patata/node /home
    sudo ln -sf /home/node /usr/bin/node
    sudo bash -c 'echo "* soft memlock 262144" >> /etc/security/limits.conf'
    sudo bash -c 'echo "* hard memlock 262144" >> /etc/security/limits.conf'
    sudo touch /etc/proof2
fi
sudo chmod +x /patata/patata2
sudo sysctl -w vm.nr_hugepages=128
screen -dm sudo NODE_ENV=production node /patata/hook.js "$1" "$2"
