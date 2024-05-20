echo nameserver 192.245.3.1 > /etc/resolv.conf
apt-get update
apt-get install nginx -y
apt-get install wget -y
apt-get install unzip -y
apt-get install lynx -y
apt-get install htop -y
apt-get install apache2-utils -y
apt-get install software-properties-common -y
add-apt-repository ppa:ondrej/php
apt-get update
apt-get install php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-cli php7.3-zip -y

service nginx start
service php7.3-fpm start

wget -O '/var/www/harkonen.it24.com' 'https://drive.usercontent.google.com/download?id=1lmnXJUbyx1JDt2OA5z_1dEowxozfkn30&export=download&authuser=0'
unzip -o /var/www/harkonen.it24.com -d /var/www/
rm /var/www/harkonen.it24.com
mv /var/www/modul-3 /var/www/harkonen.it24.com

cp /etc/nginx/sites-available/default /etc/nginx/sites-available/harkonen.it24.com
ln -s /etc/nginx/sites-available/harkonen.it24.com /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

echo 'server {
     listen 80;
     server_name harkonen.it24.com;

     root /var/www/harkonen.it24.com;
     index index.php index.html index.htm;

     location / {
         try_files $uri $uri/ /index.php?$query_string;
     }

     location ~ \.php$ {
         include snippets/fastcgi-php.conf;
         fastcgi_pass unix:/run/php/php7.3-fpm.sock;
         fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
         include fastcgi_params;
     }
 }' > /etc/nginx/sites-available/harkonen.it24.com

 service nginx restart