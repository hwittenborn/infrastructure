server {
  server_name docs.hunterwittenborn.com;
  listen 443 ssl;
  location /makedeb {
    return 301 https://makedeb.hunterwittenborn.com;
  }
  
  ssl_certificate /etc/letsencrypt/live/hunterwittenborn.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/hunterwittenborn.com/privkey.pem;
}
