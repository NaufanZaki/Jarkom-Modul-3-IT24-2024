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
0. `ping harkonen.it24.com` dan `ping atreides.it24.com` pada php worker
1-5. Test ping pada client

![image](https://github.com/NaufanZaki/Jarkom-Modul-3-IT242024/assets/111356493/45b30608-2f2b-4275-9c40-8c016cb738b2)

### Soal 6

`vladimir.sh`
`rabban.sh`
`feyd.sh`

```

echo nameserver 192.245.3.1 > /etc/resolv.conf
apt-get update
apt-get install nginx -y
apt-get install wget -y
apt-get install unzip -y
apt-get install lynx -y
apt-get install htop -y
apt-get install apache2-utils -y
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

```

**Test:**
- bash
  `vladimir.sh`
  `rabban.sh`
  `feyd.sh`

![6  bash](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/26e71839-f233-4d6f-8196-b17961379251)


![6  bash2](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/7361da17-ae50-484d-ba93-e898db4aa3bf)

- lynx localhost

![6  test](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/86a015d3-fae9-4268-8a5a-e6c349a9eb53)

### Soal 7

`irulan.sh` setting agar ip  nya menuju ke stilgar

```

echo 'nameserver 192.168.122.1' > /etc/resolv.conf
apt-get update
apt-get install bind9 -y  

echo 'zone "atreides.it24.com" {
    type master;
    file "/etc/bind/sites/atreides.it24.com";
};

zone "harkonen.it24.com" {
    type master;
    file "/etc/bind/sites/harkonen.it24.com";
};' > /etc/bind/named.conf.local


mkdir -p /etc/bind/sites
cp /etc/bind/db.local /etc/bind/sites/atreides.it24.com
cp /etc/bind/db.local /etc/bind/sites/harkonen.it24.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     atreides.it24.com. root.atreides.it24.com. (
                        2023111401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      atreides.it24.com.
@       IN      A       192.245.4.2    ; 
www     IN      CNAME   atreides.it24.com.' > /etc/bind/sites/atreides.it24.com

echo '
:
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     harkonen.it24.com. root.harkonen.it24.com. (
                        2023111401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      harkonen.it24.com.
@       IN      A       192.245.4.2     ; IP Lugner
www     IN      CNAME   harkonen.it24.com.' > /etc/bind/sites/harkonen.it24.com

echo 'options {
      directory "/var/cache/bind";

      forwarders {
              192.168.122.1;
      };

      // dnssec-validation auto;
      allow-query{any;};
      auth-nxdomain no;    # conform to RFC1035
      listen-on-v6 { any; };
}; ' > /etc/bind/named.conf.options

service bind9 start

```

`stilgar.sh`

```

echo 'nameserver 192.245.3.1' > /etc/resolv.conf
apt-get update
apt-get install apache2-utils -y
apt-get install nginx -y
apt-get install lynx -y

service nginx start

cp /etc/nginx/sites-available/default /etc/nginx/sites-available/lb_php

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
        proxy_pass http://worker;
    }
} ' > /etc/nginx/sites-available/lb_php

ln -s /etc/nginx/sites-available/lb_php /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

service nginx restart

```

`client.sh`

```

apt update
apt install lynx -y
apt install htop -y
apt install apache2-utils -y
apt-get install jq -y

```

**Test:**

- bash
  irulan.sh
  stilgar.sh
  client.sh

- ab -n 5000 -c 150 http://www.harkonen.it24.com/
  di client(paul/dmitri)

![7  test1](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/0e915c92-981e-4d38-9723-15e8fce9913e)

![7  test2](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/ad24e17e-544a-46f2-998c-dffcb4ad70ef)

### Soal 8

**Algoriitma Round-Robin**

Pada `stilgar.sh`

```

# Round-robin
upstream worker {
    server 10.65.3.2;
    server 10.65.3.3;
    server 10.65.3.4;
}

```

Pada client (paul/dmitri)

- ab -n 500 -c 50 http://www.harkonen.it24.com/

![8 test1 round robin](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/618c4196-92c4-471d-9402-b7e083d4923b)

![8 test2 round robin](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/7e34731c-9dca-4445-86b4-3a9590715736)

- htop

![8 htop round robin](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/23c6d04c-e920-41bf-9a56-695b95b04c37)

Pada `stilgar.sh`

```

# Generic hash
upstream worker {
    hash $request_uri consistent;
    server 10.65.3.2;
    server 10.65.3.3;
    server 10.65.3.4;
}

```

Pada client (paul/dmitri)
- ab -n 500 -c 50 http://www.harkonen.it24.com/

![8 test1 generic hash](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/eeed05f0-960d-4c12-9ca4-3505228f8027)

![8 test2 generic hash](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/9b2a80e5-9e94-4f2f-8ea1-5d38d4aa5077)

- htop

![8 htop generic hash](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/071d7408-5bf6-46f2-a19c-98499d74d78b)

Pada `stilgar.sh`

```

# Least connection
upstream worker {
    least_conn;
    server 10.65.3.2;
    server 10.65.3.3;
    server 10.65.3.4;
}

```

Pada client (paul/dmitri)
- ab -n 500 -c 50 http://www.harkonen.it24.com/

![8 test1 least connection](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/d537d02d-95e2-41f6-9031-53452dbc0618)

![8 test2 least connection](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/e4d28555-e908-414f-9f49-adab3f68672c)

- htop

![8 htop least connection](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/040bda5b-8e2a-4942-b6c3-bfeb4e09363d)

  
Pada `stilgar.sh`

```

# IP hash
upstream worker {
    ip_hash;
    server 10.65.3.2;
    server 10.65.3.3;
    server 10.65.3.4;
}

```

Pada client (paul/dmitri)
- ab -n 500 -c 50 http://www.harkonen.it24.com/

![8 test1 ip hash](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/8b92fd3b-fc54-48a5-9802-ecf9b7a53f27)

![8 test2 ip hash](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/b84fa851-3779-4161-b9d5-fc293c410b85)

- htop

![8 htop ip hash](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/662cb339-4f75-4caf-8613-d0bd7c653548)

**Grafik**

![8 grafik](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/658101b6-97d4-413f-ab31-6d48697b3a50)



### Soal 9

Pada `stilgar.sh`, untuk 3 worker:

```

# Least connection
upstream worker {
    least_conn;
    server 10.65.3.2;
    server 10.65.3.3;
    server 10.65.3.4;
}

```

Pada client (paul/dmitri)
- ab -n 1000-c 10 http://www.harkonen.it24.com/

![9  test1 3worker](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/1901fbf3-74c1-4722-a438-00f1742f14ed)

![9  test2 3worker](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/dabba824-9c2c-425a-b52a-a228cda7b6a8)

- htop

![9  htop 3worker](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/3f551c7e-0abf-4be9-ae3a-d71901f7dd48)


Pada `stilgar.sh`, untuk 2 worker:

```

# Least connection
upstream worker {
    least_conn;
    server 10.65.3.2;
    server 10.65.3.3;
   #server 10.65.3.4;
}

```

Pada client (paul/dmitri)
- ab -n 1000-c 10 http://www.harkonen.it24.com/

![9  test1 2worker](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/1190a03f-de4a-4b87-b62c-3f30580e03d6)

![9  test2 2worker](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/ccfd9f8a-ef4e-47bc-84ee-348055832eee)

- htop

![9  htop 2worker](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/5b5a15d3-a847-4850-8b8f-7fbd4214339b)


Pada `stilgar.sh`, untuk 1 worker:

```

# Least connection
upstream worker {
    least_conn;
    server 10.65.3.2;
   #server 10.65.3.3;
   #server 10.65.3.4;
}

```

Pada client (paul/dmitri)
- ab -n 1000-c 10 http://www.harkonen.it24.com/

![9  test1 1worker](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/5b729907-e595-4eec-8768-393517ab3cf8)

![9  test2 1worker](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/e4b5d93f-0156-4a11-83d3-47bd73f8b31a)

- htop

![9  htop 1worker](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/1441240c-0bd4-417e-b987-d53ad1260843)

**Grafik**

![9  grafik](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/c4f9ea21-9702-41ed-b5bf-a6acbaf369f9)


### Soal 10

Pada load balancer

`stilgar10.1.sh`

```

echo 'REMINDER: masukkan password kcksit24'
mkdir /etc/nginx/supersecret
htpasswd -c /etc/nginx/supersecret/htpasswd secmart

```

`stilgar10.sh`

```

echo 'nameserver 192.245.3.1' > /etc/resolv.conf

apt-get update
apt-get install apache2-utils -y
apt-get install nginx -y
apt-get install lynx -y

service nginx start

cp /etc/nginx/sites-available/default /etc/nginx/sites-available/lb_php

echo 'upstream worker {
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
        proxy_pass http://worker;

        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/supersecret/htpasswd;
    }
}' > /etc/nginx/sites-available/lb_php

ln -s /etc/nginx/sites-available/lb_php /etc/nginx/sites-enabled/

if [ -f /etc/nginx/sites-enabled/default ]; then
    rm /etc/nginx/sites-enabled/default
fi   

service nginx restart

```

Pada client
- lynx http://harkonen.it24.com/
- masukkan user: secmart, password: kcksit24

![10  hasil](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/f34159ee-15b6-4041-9043-a362c1b4e755)

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

### Soal 16

buat `login.json` di dmitri

```

{
"username" : "secmart",
"password" : "kcksit24"
}

```

- ` ab -n 100 -c 10 -p login.json -T application/json http://192.245.2.1:8001/api/auth/login`

![16](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/ff09dd16-b33e-436d-b28e-f3ff6c8b87ea)

![16  2](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/e031426d-7ef2-4a33-ab4f-9f727accb55d)

### Soal 17

- curl -X POST -H "Content-Type: application/json" -d @login.json http://192.245.2.1:8001/api/auth/login > login_output.txt
- ab -n 100 -c 10 -H "Authorization: Bearer $token" http://192.245.2.1:8001/api/me

![17  curl](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/c84e80bb-bb06-4362-8a02-941f67199a2d)

![17  hasil1](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/bf5faaaf-6251-4e49-bf91-39e76191f353)

![17 hasil2](https://github.com/NaufanZaki/Jarkom-Modul-3-IT24-2024/assets/124648489/1504f754-856c-495f-bead-fc456c5714c1)







