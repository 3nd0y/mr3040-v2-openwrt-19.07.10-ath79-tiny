#!/bin/sh

echo "[+] Mengaktifkan IP Forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "[+] Flush aturan iptables lama..."
iptables -F
iptables -t nat -F
iptables -X

uci delete wireless.@wifi-iface[0]
uci delete wireless.@wifi-iface[0]
uci delete wireless.@wifi-iface[0]

echo "[+] Konfigurasi Wi-Fi sebagai Client..."
uci add wireless wifi-iface
uci set wireless.@wifi-iface[0].mode='sta'
uci set wireless.@wifi-iface[0].network='wwan'
uci set wireless.@wifi-iface[0].ssid='AL GHWEIFAT'
uci set wireless.@wifi-iface[0].encryption='psk2'
uci set wireless.@wifi-iface[0].key='safetyfirst'
uci commit wireless
wifi reload

echo "[+] Atur IP statik untuk Ethernet..."
ifconfig eth0 192.168.20.1 netmask 255.255.255.0 up

# echo "[+] Konfigurasi Firewall untuk wwan ➜ LAN..."
# uci batch <<EOF
# set firewall.@zone[1].name='wwan'
# set firewall.@zone[1].network='wwan'
# set firewall.@zone[1].masq='1'
# set firewall.@zone[1].forward='REJECT'
# set firewall.@zone[1].input='ACCEPT'
# set firewall.@zone[1].output='ACCEPT'

# add firewall forwarding
# set firewall.@forwarding[-1].src='wwan'
# set firewall.@forwarding[-1].dest='lan'
# EOF
# uci commit firewall
# /etc/init.d/firewall restart

echo "[✓] Mode STA aktif: Wi-Fi ➜ Ethernet"
