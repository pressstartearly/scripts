mkdir /backup/

cd /srv/daemon

git rm --cached

git add -A

git remote add origin https://github.com/pressstartearly/daemon.git

git pull origin master

systemctl restart wings
