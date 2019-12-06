                                                                                                                                                                  
echo "What is the domain name you want to use?"                                                                                                                   
read ccdomain                                                                                                                                                     
                                                                                                                                                                  
echo "What is the domain or IP address you want to proxy? (Dynmap IP and port)"                                                                                   
read ccip                                                                                                                                                         
                                                                                                                                                                  
echo " server {                                                                                                                                                   
        server_name $ccdomain;                                                                                                                                    
        listen 80;                                                                                                                                                
        listen [::]:80;                                                                                                                                           
        access_log /var/log/nginx/reverse-access.log;                                                                                                             
        error_log /var/log/nginx/reverse-error.log;                                                                                                               
        location / {                                                                                                                                              
                    proxy_pass http://$ccip;                                                                                                                      
  }                                                                                                                                                               
} " > /etc/nginx/sites-available/$ccdomain.conf                                                                                                                   
                                                                                                                                                                  
ln -s /etc/nginx/sites-available/$ccdomain.conf /etc/nginx/sites-enabled/$ccdomain.conf                                                                           
                                                                                                                                                                  
certbot --nginx                                                                                                                                                   
                                                                                                                                                                  
echo "Done! :)"          
