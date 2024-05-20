#!/bin/bash

echo 'nameserver 192.245.3.1' >> /etc/resolv.conf   # Pastikan DNS Server sudah berjalan
apt-get update
apt-get install isc-dhcp-server -y

interfaces="INTERFACESv4=\"eth0\"
INTERFACESv6=\"\"
"
echo "$interfaces" > /etc/default/isc-dhcp-server

subnet="option domain-name \"example.org\";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

ddns-update-style-none;

subnet 192.245.1.0 netmask 255.255.255.0 {
    range 192.245.1.14 192.245.1.28;
    range 192.245.1.49 192.245.1.70;
    option routers 192.245.1.0;
    option broadcast-address 192.245.1.255;
    option domain-name-servers 192.245.3.1;
    default-lease-time 300;
    max-lease-time 5220;
}

subnet 192.245.2.0 netmask 255.255.255.0 {
    range 192.245.2.15 192.245.2.25;
    range 192.245.2.200 192.245.2.210;
    option routers 192.245.2.0;
    option broadcast-address 192.245.2.255;
    option domain-name-servers 192.245.3.1;
    default-lease-time 1200;
    max-lease-time 5220;
}

subnet 192.245.3.0 netmask 255.255.255.0 {
}

subnet 192.245.4.0 netmask 255.255.255.0 {
}

host Dimitri {
    hardware ethernet 86:2f:63:5a:78:ac;
    fixed-address 192.245.1.37;
}
"
echo "$subnet" > /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart