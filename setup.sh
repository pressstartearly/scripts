apt-get update

apt install -y zip unzip tar make gcc g++ python python-dev curl gnupg git

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

#--- CPU Govener ----
echo " ### Hetzner Online GmbH - installimage
# cpu frequency scaling
ENABLE=\"true\"
GOVERNOR=\"preformance\"
MAX_SPEED=\"0\"
MIN_SPEED=\"0\" " > /etc/default/cpufrequtils

systemctl restart cpufrequtils

#--- Update GRUB ---
echo " # If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'

GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT=\"nomodeset consoleblank=0 swapaccount=1\"
GRUB_CMDLINE_LINUX=\"\"

# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM=\"0x01234567,0xfefefefe,0x89abcdef,0xefefefef\"

# Uncomment to disable graphical terminal (grub-pc only)
#GRUB_TERMINAL=console

# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command 'vbeinfo'
#GRUB_GFXMODE=640x480

# Uncomment if you don't want GRUB to pass \"root=UUID=xxx\" parameter to Linux
#GRUB_DISABLE_LINUX_UUID=true

# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY=\"true\"

# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE=\"480 440 1\" " > /etc/default/grub

update-grub

#--- Cockpit ---

apt-get install -y cockpit

mkdir -p /srv/daemon /srv/daemon-data

cd /srv/daemon

git init

git remote add origin https://github.com/pressstartearly/daemon.git

git pull origin master

npm install --only=production

add-apt-repository ppa:certbot/certbot
apt update
apt install -y certbot

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

echo "What shall this server be called?"
read ccname
echo "$ccname" > /etc/hostname

restart now
