mkdir /srv/backups

cd /srv

wget https://raw.githubusercontent.com/pressstartearly/scripts/master/backup.sh

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "0 */12 * * * bash /srv/backup.sh" >> mycron
#install new cron file
crontab mycron
rm mycron

curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

/usr/local/bin/aws2 configure

echo "done"
