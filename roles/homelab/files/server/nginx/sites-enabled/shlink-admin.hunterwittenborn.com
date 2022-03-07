server {
  server_name shlink-admin.hunterwittenborn.com;
  listen 443 ssl;
  location / {
    proxy_pass http://localhost:5061;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
  }

  ssl_certificate /etc/letsencrypt/live/homelab/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/homelab/privkey.pem;
}
