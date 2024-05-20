# Praktikum Modul 3
| Nama | NRP |
| --------------------- | ----------------------- |
| Monika Damelia Hutapea | 5027221011 |
| Naufan Zaki Lugmanulhakim | 5027221065 |
## Configuration
### Arakis (Router)
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.245.1.0
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.245.2.0
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.245.3.0
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 192.245.4.0
	netmask 255.255.255.0
```
### Mohiam (DHCP Server)
```
auto eth0
iface eth0 inet static
	address 192.245.3.2
	netmask 255.255.255.0
	gateway 192.245.3.0
```
### Irulan (DNS Server)
```
auto eth0
iface eth0 inet static
	address 192.245.4.1
	netmask 255.255.255.0
	gateway 192.245.4.0
```
### Chani (Database Server)
```
auto eth0
iface eth0 inet static
	address 192.245.4.1
	netmask 255.255.255.0
	gateway 192.245.4.0
```
### Stilgar (Load Balancer)
```
auto eth0
iface eth0 inet static
	address 192.245.4.2
	netmask 255.255.255.0
	gateway 192.245.4.0
```
### Leto (Laravel Worker)
```
auto eth0
iface eth0 inet static
	address 192.245.2.1
	netmask 255.255.255.0
	gateway 192.245.2.0
```
### Duncan (Laravel Worker)
```
auto eth0
iface eth0 inet static
	address 192.245.2.2
	netmask 255.255.255.0
	gateway 192.245.2.0
```
### Jessica (Laravel Worker)
```
auto eth0
iface eth0 inet static
	address 192.245.2.3
	netmask 255.255.255.0
	gateway 192.245.2.0
```
### Vladimir (PHP Worker)
```
auto eth0
iface eth0 inet static
	address 192.245.1.1
	netmask 255.255.255.0
	gateway 192.245.1.0
```
### Rabban (PHP Worker)
```
auto eth0
iface eth0 inet static
	address 192.245.1.2
	netmask 255.255.255.0
	gateway 192.245.1.0
```
### Feyd (PHP Worker)
```
auto eth0
iface eth0 inet static
	address 192.245.1.3
	netmask 255.255.255.0
	gateway 192.245.1.0
```
## Instalasi (`.bashrc` masing-masing node)
### Arakis (DHCP Relay)
```
apt-get update
apt-get install isc-dhcp-server
```
### Irulan (DNS Server)
```
apt-get update
apt-get install bind9 -y
```
### Mohiam (DHCP Server)
```
apt-get update
apt-get install bind9 -y
```
### Stilgar (Load Balancer)
```
apt-get update
apt-get install apache2-utils -y
apt-get install nginx -y
apt-get install lynx -y
```
### Chani (Database Server)
```
apt-get update
apt-get install mariadb-server -y
```
## Pengerjaan Soal
### Soal 1-5
`irulan.sh`
```echo 'nameserver 192.168.122.1' > /etc/resolv.conf
apt-get update
apt-get install bind9 -y

forward="options {
directory \"/var/cache/bind\";
forwarders {
           192.168.122.1;
};

allow-query{any;};
listen-on-v6 { any; };
};
"
echo "$forward" > /etc/bind/named.conf.options

echo "zone \"atreides.it24.com\" {
        type master;
        file \"/etc/bind/jarkom/atreides.it24.com\";
};

zone \"harkonen.it24.com\" {
        type master;
        file \"/etc/bind/jarkom/harkonen.it24.com\";
};
" > /etc/bind/named.conf.local

mkdir /etc/bind/jarkom

# atreides, ip leto 192.245.2.1
# harkonen, ip Vladimir 192.245.1.1
# ip stilgar  192.245.4.2

atreides="
;
;BIND data file for local loopback interface
;
\$TTL    604800
@    IN    SOA    atreides.it24.com. root.atreides.it24.com. (
        2        ; Serial
                604800        ; Refresh
                86400        ; Retry
                2419200        ; Expire
                604800 )    ; Negative Cache TTL
;
@    IN    NS    atreides.it24.com.
@       IN    A    192.245.2.1
"
echo "$atreides" > /etc/bind/jarkom/atreides.it24.com

harkonen="
;
;BIND data file for local loopback interface
;
\$TTL    604800
@    IN    SOA    harkonen.it24.com. root.harkonen.it24.com. (
        2        ; Serial
                604800        ; Refresh
                86400        ; Retry
                2419200        ; Expire
                604800 )    ; Negative Cache TTL
;
@    IN    NS    harkonen.it24.com.
@       IN    A    192.245.1.1
"
echo "$harkonen" > /etc/bind/jarkom/harkonen.it24.com

service bind9 start
```
`ping harkonen.it24.com` dan `ping atreides.it24.com` pada client


### Soal 11
`stilgar.sh`
```
    location ~ /dune {
    proxy_pass https://www.dunemovie.com.au;
    proxy_set_header Host www.dunemovie.com.au;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
} ' > /etc/nginx/sites-available/lb_php
```
Menjalankan command ini pada client

` lynx http://harkonen.it24.com/dune`

### Soal 12
Tambahkan ini pada LB
```
location / {
		allow 192.245.1.37;
        allow 192.245.1.67;
        allow 192.245.2.203;
        allow 192.245.2.207;
        deny all;
        proxy_pass http://worker;
    }
```
hanya bisa diakses di dmitri
### Soal 13

![nomor13](image-2.png)

### Soal 14
Lakukan instalasi ini
```
apt-get install php8.0-mbstring php8.0-xml php8.0-cli php8.0-common php8.0-intl php8.0-opcache php8.0-readline php8.0-mysql php8.0-fpm php8.0-curl unzip wget -y
wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer
```
Clone `https://github.com/martuafernando/laravel-praktikum-jarkom`

konfigurasi env
```
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=10.65.2.2
DB_PORT=3306
DB_DATABASE=dbkelompokit03
DB_USERNAME=kelompokit03
DB_PASSWORD=passwordit03
```
USE dbkelompokit24;
![alt text](image-3.png)

akses melalui port 8001 (leto)
![leto14](image-4.png)

![alt text](image-5.png)

### Soal 15
buat `register.json` di dmitri

```{
"username" : "secmart",
"password" : "kcksit24"
}
```
` ab -n 100 -c 10 -p register.json -T application/json http://192.245.2.1:8001/api/auth/register` pada dmitri dengan tujuan leto
![alt text](image-6.png)

