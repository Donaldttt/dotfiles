SERVERIP=x.useless.pw
ip=$(ifconfig | grep -Po 10.0.0.[01][0-9]+)
[ "$ip" != "" ] && SERVERIP=10.0.0.100
