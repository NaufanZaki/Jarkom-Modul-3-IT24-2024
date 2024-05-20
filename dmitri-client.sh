apt update
apt install lynx -y
apt install htop -y
apt install apache2-utils -y
apt-get install jq -y

config="auto eth0
iface eth0 inet dhcp
hwaddress ether 86:2f:63:5a:78:ac
"
echo "$config" > /etc/network/interfaces

echo '
{
  "username": "secmart",
  "password": "kcksit24"
}
' > register.json