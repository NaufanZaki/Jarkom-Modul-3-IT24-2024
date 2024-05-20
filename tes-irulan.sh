echo 'nameserver 192.168.122.1' > /etc/resolv.conf
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
@       IN    A    192.245.4.2
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
@       IN    A    192.245.4.2
"
echo "$harkonen" > /etc/bind/jarkom/harkonen.it24.com

service bind9 start