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

mkdir -p /srv/daemon /srv/daemon-data

cd /srv/daemon

git clone git://github.com/pressstartearly/daemon.git
