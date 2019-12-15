datecc=$(date '+%d/%m/%Y-%H:%M:%S');
backupName=backup-$HOSTNAME-$datecc.zip

zip /srv/daemon-data /srv/backups/$backupName

aws s3 cp /srv/backups/$backupName s3://dedimc.backups/$backupName

rm /srv/backups/$backupName

echo "Done"

