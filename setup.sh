apt-get update

apt install -y zip unzip tar make gcc g++ python python-dev curl gnupg

## install apt tools
apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

## Import the docker gpg key
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

## Add the docker stable repo
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

## Install docker
apt update -y
apt install -y docker-ce

systemctl enable docker
systemctl start docker

## Install nodejs repo
curl -sL https://deb.nodesource.com/setup_10.x | bash -


## Install nodejs
apt install -y nodejs

## -----UFW-----

apt-get install -y ufw
ufw allow OpenSSH
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 25565
ufw allow 25566
ufw allow 25567
ufw allow 25568
ufw allow 25569
ufw allow 8080
ufw allow 2022
ufw allow 9090
ufw default deny incoming
ufw default allow outgoing
ufw enable

#--- MOTD ----
echo "##################################################
## THIS SERVER IS PROPERTY OF DEDICATED MC, LLC ##
##    UNAUTHORIZED USE IS STRICLY FORBIDDEN     ##
##################################################" > /etc/motd

apt-get install cockpit

mkdir -p /srv/daemon /srv/daemon-data

cd /srv/daemon

git init

git remote add origin https://github.com/pressstartearly/daemon.git

git pull origin master

npm install --only=production

sudo add-apt-repository ppa:certbot/certbot
sudo apt update
sudo apt install -y certbot

echo "What is the domain name for this node?"
read ccdomain

certbot certonly -d $ccdomain

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "@monthly certbot renew" >> mycron
#install new cron file
crontab mycron
rm mycron

echo "What is the auto config command?"
read ccconfig
$ccconfig

echo "[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service

[Service]
User=root
#Group=some_group
WorkingDirectory=/srv/daemon
LimitNOFILE=4096
PIDFile=/var/run/wings/daemon.pid
ExecStart=/usr/bin/node /srv/daemon/src/index.js
Restart=on-failure
StartLimitInterval=600

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/wings.service

systemctl enable --now wings
