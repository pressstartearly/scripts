mkdir /backup/

git config --global user.email "caleb@dedicatedmc.io"

zip -r daemon.zip /srv/daemon

cd /srv/daemon

git init

git remote add origin https://github.com/pressstartearly/daemon.git

git rm --cached

git add -A

git stash

git pull origin master

git stash pop

npm install --only=production

systemctl restart wings
