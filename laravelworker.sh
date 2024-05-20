echo 'nameserver 192.245.3.1' >> /etc/resolv.conf
apt-get update
apt-get install mariadb-client -y
apt-get install lynx -y
apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt-get update
apt-get install php8.0-mbstring php8.0-xml php8.0-cli php8.0-common php8.0-intl php8.0-opcache php8.0-readline php8.0-mysql php8.0-fpm php8.0-curl unzip wget -y
apt-get install nginx -y
wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer
apt-get install git -y
git clone https://github.com/martuafernando/laravel-praktikum-jarkom /var/www/laravel-praktikum-jarkom
composer update
composer install

echo 'APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=192.245.4.1
DB_PORT=3306
DB_DATABASE=dbkelompokit24
DB_USERNAME=secmart
DB_PASSWORD=kcksit24

' > /var/www/laravel-praktikum-jarkom/.env

service nginx start

cd /var/www/laravel-praktikum-jarkom
composer update
composer install
service nginx start
php artisan migrate:fresh
php artisan db:seed --class=AiringsTableSeeder
php artisan key:generate
php artisan config:cache
php artisan migrate
php artisan db:seed
php artisan storage:link
php artisan jwt:secret
php artisan config:clear
chown -R www-data.www-data /var/www/laravel-praktikum-jarkom/storage

echo 'server {

    listen 8001;
    # sesuaikan port dengan worker

    root /var/www/laravel-praktikum-jarkom/public;

    index index.php index.html index.htm;
    server_name _;

    location / {
            try_files $uri $uri/ /index.php?$query_string;
    }

    # pass PHP scripts to FastCGI server
    location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
    }

location ~ /\.ht {
            deny all;
    }

    error_log /var/log/nginx/fff_error.log;
    access_log /var/log/nginx/fff_access.log;
}
' > /etc/nginx/sites-available/fff

ln -s /etc/nginx/sites-available/fff /etc/nginx/sites-enabled/
chown -R www-data.www-data /var/www/laravel-praktikum-jarkom/storage
service php8.0-fpm start
service nginx restart