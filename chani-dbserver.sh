echo 'nameserver 192.245.3.1' >> /etc/resolv.conf 
apt-get update
apt-get install mariadb-server -y
service mysql start

mysql -e "CREATE USER 'secmart'@'%' IDENTIFIED BY 'kcksit24';"
mysql -e "CREATE USER 'secmart'@'harkonen.it24.com' IDENTIFIED BY 'kcksit24';"
mysql -e "CREATE DATABASE dbsecmart;"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'secmart'@'%';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'secmart'@'harkonen.it24.com';"
mysql -e "FLUSH PRIVILEGES;"

mysql="[mysqld]
skip-networking=0
skip-bind-address
"
echo "$mysql" > /etc/mysql/my.cnf

service mysql restart