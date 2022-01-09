server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  
  allow 173.21.54.87;
  deny all;

  server_name mailcow.hunterwittenborn.com autodiscover.hunterwittenborn.com autoconfig.hunterwittenborn.com;

  ssl_session_timeout 1d;
  ssl_session_cache shared:SSL:50m;
  ssl_session_tickets off;

  location /Microsoft-Server-ActiveSync {

    proxy_pass http://127.0.0.1:5070/Microsoft-Server-ActiveSync;

    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_connect_timeout 75;
    proxy_send_timeout 3650;
    proxy_read_timeout 3650;
    proxy_buffers 64 256k;
    client_body_buffer_size 512k;
    client_max_body_size 0;
  }

  location / {

    proxy_pass http://127.0.0.1:5070/;

    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    client_max_body_size 0;
  }
  
  ssl_certificate /etc/letsencrypt/live/hunterwittenborn.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/hunterwittenborn.com/privkey.pem;
}
