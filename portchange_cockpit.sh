# Change file to use port 5050
echo "[Unit]
Description=Cockpit Web Service Socket
Documentation=man:cockpit-ws(8)
Wants=cockpit-motd.service

[Socket]
ListenStream=5050
ExecStartPost=-/usr/share/cockpit/motd/update-motd '' localhost
ExecStartPost=-/bin/ln -snf active.motd /run/cockpit/motd
ExecStopPost=-/bin/ln -snf /usr/share/cockpit/motd/inactive.motd /run/cockpit/motd

[Install]
WantedBy=sockets.target" > /usr/lib/systemd/system/cockpit.socket

# Restart Services
systemctl daemon-reload
systemctl restart cockpit.service

# Allow Port
ufw allow 5050

echo "Cockpit port changed and configurated properly!"
