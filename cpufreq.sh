apt-get install -y cpufrequtils

echo "# cpu frequency scaling
ENABLE=\"true\"
GOVERNOR=\"performance\"
MAX_SPEED=\"0\"
MIN_SPEED=\"0\" " > /etc/default/cpufrequtils

systemctl restart cpufrequtils

cpufreq-info
