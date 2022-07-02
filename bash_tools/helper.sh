# get self-host server ip
SERVERIP=x.useless.pw

$(which ifconfig > /dev/null 2>&1) && \
    ip=$(ifconfig | grep -Po "10.0.0.[01][0-9]+")

[ "$ip" != "" ] && SERVERIP=10.0.0.100
