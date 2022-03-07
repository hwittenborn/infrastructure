server {
  server_name docs.hunterwittenborn.com;
  listen 443 ssl;
  location /makedeb {
    return 301 https://makedeb.hunterwittenborn.com;
  }
  
  ssl_certificate /etc/letsencrypt/live/homelab/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/homelab/privkey.pem;
}
