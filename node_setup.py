apt update
apt install -y pipenv git build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev
cd /opt
wget https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tgz
tar xzf Python-3.8.3.tgz
cd Python-3.8.3
./configure --enable-optimizations
make altinstall

mkdir servus
cd servus
git clone https://github.com/DedicatedMC/setup-bot.git
cd setup-bot

pipenv install





