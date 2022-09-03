server {
  server_name www.hunterwittenborn.com;
  listen 443 ssl;
  rewrite ^(.*)$ https://hunterwittenborn.com$1 redirect;
  
  ssl_certificate /etc/letsencrypt/live/homelab/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/homelab/privkey.pem;
}

server {
  server_name hunterwittenborn.com;
  listen 443 ssl;
  root /var/www/hunterwittenborn.com;
  error_page 404 /404.html;
  
  ssl_certificate /etc/letsencrypt/live/homelab/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/homelab/privkey.pem;
}
