Install docker, along with docker compose plugin:
[https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)

Follow this guide to start the CTFd:
[https://docs.ctfd.io/docs/deployment/installation/](https://docs.ctfd.io/docs/deployment/installation/
)

Once you have CTFd working, change the contents 
of `docker-compose.yml` to similar to `fairgame-docker-compose.yml` (specifically, include the certbot service).

Also modify the server block in `./conf/nginx/http.conf` to contain the following
```
...
listen 80;
server_name your_domain_name;

gzip on;

client_max_body_size 4G;

# certbot challenge requests
location /.well-known/acme-challenge/ {
    root /var/www/certbot;
    allow all;
}

location /events {
    ...
```

Then, while the docker compose for CTFd is running, run
```bash
docker compose run --rm certbot certonly --webroot -w /var/www/certbot -d your_domain_name
```
to generate the SSL certificates.

Now, change the contents of `./conf/nginx/http.conf` entirely, to be similar to the following (replacing `your_domain_name`):
```
worker_processes 4;

events {

  worker_connections 1024;
}

http {

  # Configuration containing list of application servers
  upstream app_servers {

    server ctfd:8000;
  }

  server {

    listen 80;
    server_name your_domain_name;

    gzip on;

    client_max_body_size 4G;

    # certbot challenge requests
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
        allow all;
    }

    # Redirect all other traffic to HTTPS
    location / {
      return 301 https://$host$request_uri;
    }
  }

  server {
    listen 443 ssl;
    server_name your_domain_name;

    ssl_certificate /etc/letsencrypt/live/your_domain_name/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your_domain_name/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;                                               ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305;
                                                                                gzip on;
    client_max_body_size 4G;

    # Certbot challenge requests
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
        allow all;
    }
    location /events {
        proxy_pass http://app_servers;
        proxy_set_header Connection '';
        proxy_http_version 1.1;
        chunked_transfer_encoding off;
        proxy_buffering off;
        proxy_cache off;
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    location / {
        proxy_pass http://app_servers;
        proxy_set_header Connection '';
        proxy_http_version 1.1;
        chunked_transfer_encoding off;
        proxy_buffering off;
        proxy_cache off;
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
}
```
Then, rerun the docker instance.
```
docker compose down
docker compose up -d
```

Now, you should be able to go to your_domain_name
and initialize the admin CTFd account and other config for the competition.


In the admin panel, go to pages -> all pages -> index
and replace the contents with the following 
to automatically redirect to the challenges.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script type="text/javascript">
        window.onload = function() {
            window.location.href = "/challenges";
        };
    </script>
</head>
<body>
    <p>This page should automatically redirect to Challenges. If it doesn't, click <a href="/challenges">here</a> to go manually.</p>
</body>
</html>
```