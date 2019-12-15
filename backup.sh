backupName = backup-$HOSTNAME-date +"%Y-%m-%d-%T".zip

zip /srv/daemon-data /srv/backups/$backupName

aws s3 cp /srv/backups/$backupName s3://dedimc.backups/$backupName

rm /srv/backups/$backupName

echo "Done"

