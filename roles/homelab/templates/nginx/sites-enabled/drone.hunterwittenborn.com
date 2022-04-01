server {
  server_name drone.hunterwittenborn.com;
  listen 443 ssl;
  location / {
    proxy_pass http://localhost:5040;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto "https";
    proxy_redirect off;
    proxy_buffering off;
  }
  
  ssl_certificate /etc/letsencrypt/live/homelab/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/homelab/privkey.pem;
}

server {
  server_name drone-env.hunterwittenborn.com;
  listen 443 ssl;
  location / {
    proxy_pass http://localhost:5041;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto "https";
    proxy_redirect off;
    proxy_buffering off;
  }
  
  ssl_certificate /etc/letsencrypt/live/homelab/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/homelab/privkey.pem;
}
