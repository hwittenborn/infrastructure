server {
  server_name hunterwittenborn.com;
  listen 443 ssl;
  root /var/www/hunterwittenborn.com;
  autoindex on;
  
  ssl_certificate /etc/letsencrypt/live/homelab/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/homelab/privkey.pem;
}
