mkdir -p /etc/pterodactyl
curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/download/v1.0.1/wings_linux_amd64
chmod u+x /usr/local/bin/wings

echo "What is the auto config command?"
read ccconfig
$ccconfig

# Stop the old daemon.
systemctl stop wings

# Delete the entire directory. There is nothing stored in here that we actually need for the
# purposes of this migration. Remeber, server data is stored in /srv/daemon-data.
rm -rf /srv/daemon

# Optionally, remove NodeJS from your system if it was not used for anything else.
apt -y remove nodejs # or: yum remove nodejs

# stop and disable the standalone sftp
systemctl disable --now pterosftp

# delete the systemd service
rm /etc/systemd/system/pterosftp.service

echo "[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
PIDFile=/var/run/wings/daemon.pid
ExecStart=/usr/local/bin/wings
Restart=on-failure
StartLimitInterval=600

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/wings.service

systemctl daemon-reload
systemctl enable --now wings
