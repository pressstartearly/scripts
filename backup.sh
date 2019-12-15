datecc=$(date '+%d-%m-%Y-%H-%M-%S');
backupName=backup-$HOSTNAME-$datecc.zip

zip -r  /srv/backups/$backupName /srv/daemon-data/*

aws s3 cp /srv/backups/$backupName s3://dedimc.backups/$backupName

rm /srv/backups/$backupName

echo "Done"


