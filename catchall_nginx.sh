#--- Install Nginx ---
apt install -y nginx

#--- Remove Default Nginx Template ---
echo "Removing Default Templates"
rm -rf /etc/nginx/sites-available/default
rm -rf /etc/nginx/sites-enabled/default

#--- Create Nginx Block ---
echo "Adding the Nginx Server Block"
echo "server {

   listen 80 default_server;
   server_name _;
   rewrite ^/$ https://dedicatedmc.io/ permanent;

}" > /etc/nginx/sites-available/default

#--- Activate Nginx Block ---
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

#--- Restart Nginx ---
systemctl restart nginx.service
echo "Nginx Block activated & service restarted!"
