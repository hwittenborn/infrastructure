server {
  server_name makedeb.hunterwittenborn.com;
  listen 443 ssl;
  root /var/www/makedeb.hunterwittenborn.com/;
  error_page 404 /404.html;
  
  ssl_certificate /etc/letsencrypt/live/hunterwittenborn.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/hunterwittenborn.com/privkey.pem;
}
