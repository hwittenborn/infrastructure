server {
  server_name api.hunterwittenborn.com;
  listen 443 ssl;
  location /private/roblox-discord-logging {
    rewrite (.*) / break;
    proxy_pass http://localhost:6000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto "https";
  }
  
  ssl_certificate /etc/letsencrypt/live/hunterwittenborn.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/hunterwittenborn.com/privkey.pem;
}
