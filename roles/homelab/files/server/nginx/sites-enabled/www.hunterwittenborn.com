server {
  server_name www.hunterwittenborn.com;
  listen 443 ssl;
  root /var/www/www.hunterwittenborn.com;
  autoindex on;
  rewrite (.*) https://github.com/hwittenborn redirect;

  ssl_certificate /etc/letsencrypt/live/hunterwittenborn.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/hunterwittenborn.com/privkey.pem;
}
