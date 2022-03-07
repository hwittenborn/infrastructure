server {
  server_name element.hunterwittenborn.com;
  listen 443 ssl;
  location / {
    proxy_pass http://localhost:5050;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto "https";
  }

  ssl_certificate /etc/letsencrypt/live/homelab/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/homelab/privkey.pem;
}
