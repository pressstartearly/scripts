mkdir /backup/

zip -r daemon.zip /srv/daemon

cd /srv/daemon

git init

git rm --cached

git add -A

git remote add origin https://github.com/pressstartearly/daemon.git

git pull origin master

npm install --only=production

systemctl restart wings
