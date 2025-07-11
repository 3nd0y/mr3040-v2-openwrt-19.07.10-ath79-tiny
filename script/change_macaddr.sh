uci set network.lan.macaddr='C8:8A:9A:9B:33:5E'
uci set wireless.@wifi-iface[0].macaddr='C8:8A:9A:9B:33:5E'
uci commit network
/etc/init.d/network restart
