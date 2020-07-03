apt-get remove -y cockpit
ufw deny 9090
ufw allow from 116.203.120.249 to any port 9090

# INSTALLING NODE_EXPORTER

# Add users for Prometheus and Node Exporter
useradd --no-create-home --shell /usr/sbin/nologin prometheus
useradd --no-create-home --shell /bin/false node_exporter

# Create Directories
mkdir /etc/prometheus
mkdir /var/lib/prometheus

# Change Ownership
chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus

# Install Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz

# Unpack
tar xvf node_exporter-0.18.1.linux-amd64.tar.gz

# Copy files to new folder
cp node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin
schown node_exporter:node_exporter /usr/local/bin/node_exporter

# Remove files
rm -rf node_exporter-0.18.1.linux-amd64.tar.gz node_exporter-0.18.1.linux-amd64

# Setup SystemD
echo "[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/node_exporter.service

# Reload
systemctl daemon-reload

# Start & Enable
systemctl start node_exporter
ssystemctl enable node_exporter

echo "Node Exporter is now succesfully installed"


# INSTALLING PROMETHEUS

sudo apt-get update && apt-get upgrade
wget https://github.com/prometheus/prometheus/releases/download/v2.16.0/prometheus-2.16.0.linux-amd64.tar.gz
tar xfz prometheus-2.16.0.linux-amd64.tar.gz
cd prometheus-2.16.0.linux-amd64

# Copy Files
cp ./prometheus /usr/local/bin/
cp ./promtool /usr/local/bin/

# Change Ownership
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool

# Copy Files
cp -r ./consoles /etc/prometheus
cp -r ./console_libraries /etc/prometheus

# Change Ownership
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries

# Remove Files
cd .. && rm -rf prometheus-2.16.0.linux-amd64

# Configure Prometheus
echo "global:
  scrape_interval:     15s
  evaluation_interval: 15s
rule_files:
  # - "first.rules"
  # - "second.rules"
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']" > /etc/prometheus/prometheus.yml
      
# Change Ownership
chown prometheus:prometheus /etc/prometheus/prometheus.yml

# Create SystemD
echo "[Unit]
  Description=Prometheus Monitoring
  Wants=network-online.target
  After=network-online.target
[Service]
  User=prometheus
  Group=prometheus
  Type=simple
  ExecStart=/usr/local/bin/prometheus \
  --config.file /etc/prometheus/prometheus.yml \
  --storage.tsdb.path /var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries
  ExecReload=/bin/kill -HUP $MAINPID
[Install]
  WantedBy=multi-user.target" > /etc/systemd/system/prometheus.service
  
# Reload
systemctl daemon-reload

# Restart & Start
systemctl enable prometheus
systemctl start prometheus

echo "Done! Make sure that both apps are running properly and not giving any errors"
