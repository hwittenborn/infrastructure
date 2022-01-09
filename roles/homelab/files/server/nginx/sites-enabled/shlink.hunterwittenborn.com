server {
  server_name shlink.hunterwittenborn.com;
  listen 443 ssl;
  location / {
    proxy_pass http://localhost:5060;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
  }

  ssl_certificate /etc/letsencrypt/live/hunterwittenborn.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/hunterwittenborn.com/privkey.pem;
}
