systemctl restart wings
cd /srv/daemon
curl -Lo sftp-server https://github.com/pterodactyl/sftp-server/releases/download/v1.0.4/sftp-server
chmod +x sftp-server
echo "[Unit]
Description=Pterodactyl Standalone SFTP Server
After=wings.service

[Service]
User=root
WorkingDirectory=/srv/daemon
LimitNOFILE=4096
PIDFile=/var/run/wings/sftp.pid
ExecStart=/srv/daemon/sftp-server
Restart=on-failure
StartLimitInterval=600

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/pterosftp.service

systemctl enable --now pterosftp
