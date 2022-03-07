server {
  server_name nextcloud.hunterwittenborn.com;
  listen 443 ssl;
  location / {
    proxy_pass http://localhost:5030;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto "https";
    client_max_body_size 0;
  }

  # Rewrites
  rewrite /.well-known/carddav    /remote.php/dav;
  rewrite /.well-known/caldav     /remote.php/dav;

  ssl_certificate /etc/letsencrypt/live/homelab/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/homelab/privkey.pem;
}
