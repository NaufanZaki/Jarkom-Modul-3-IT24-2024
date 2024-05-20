echo 'nameserver 192.245.3.1' > /etc/resolv.conf
apt-get update
apt-get install apache2-utils -y
apt-get install nginx -y
apt-get install lynx -y

service nginx start

cp /etc/nginx/sites-available/default /etc/nginx/sites-available/lb_php
mkdir /etc/nginx/supersecret
htpasswd -c /etc/nginx/supersecret/htpasswd secmart


echo ' upstream worker {
    #    hash $request_uri consistent;
    #    least_conn;
    #    ip_hash;
    server 192.245.1.1;
    server 192.245.1.2;
    server 192.245.1.3;
}

server {
    listen 80;
    server_name harkonen.it24.com www.harkonen.it24.com;

    root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        allow 192.245.1.37;
        allow 192.245.1.67;
        allow 192.245.2.203;
        allow 192.245.2.207;
        deny all;
        proxy_pass http://worker;
        auth_basic "Restricted Content";
auth_basic_user_file /etc/nginx/supersecret/htpasswd;
    }
    location ~ /dune {
    proxy_pass https://www.dunemovie.com.au;
    proxy_set_header Host www.dunemovie.com.au;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
} ' > /etc/nginx/sites-available/lb_php

ln -s /etc/nginx/sites-available/lb_php /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

service nginx restart