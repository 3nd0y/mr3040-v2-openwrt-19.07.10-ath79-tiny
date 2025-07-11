#!/bin/sh

echo "[+] Aktifkan IP Forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "[+] Flush aturan iptables lama..."
iptables -F
iptables -t nat -F
iptables -X

uci delete wireless.@wifi-iface[0]
uci delete wireless.@wifi-iface[1]

echo "[+] Konfigurasi Wi-Fi sebagai Client (uplink)..."
uci add wireless wifi-iface
uci set wireless.@wifi-iface[0].mode='sta'
uci set wireless.@wifi-iface[0].network='wwan'
uci set wireless.@wifi-iface[0].ssid='AL GHWEIFAT'
uci set wireless.@wifi-iface[0].encryption='psk2'
uci set wireless.@wifi-iface[0].key='safetyfirst'
uci commit wireless

echo "[+] Tambahkan interface AP untuk relay..."
uci add wireless wifi-iface
uci set wireless.@wifi-iface[1].device='radio0'
uci set wireless.@wifi-iface[1].mode='ap'
uci set wireless.@wifi-iface[1].network='lan'
uci set wireless.@wifi-iface[1].ssid='Nexus-5'
uci set wireless.@wifi-iface[1].encryption='psk2'
uci set wireless.@wifi-iface[1].key='fadli1987'
uci commit wireless
wifi reload

echo "[+] Atur IP statik untuk AP..."
ifconfig wlan0 192.168.2.1 netmask 255.255.255.0 up

echo "[+] Konfigurasi DHCP untuk klien AP..."
uci set dhcp.lan.interface='lan'
uci set dhcp.lan.start='100'
uci set dhcp.lan.limit='50'
uci set dhcp.lan.leasetime='12h'
uci commit dhcp
/etc/init.d/dnsmasq restart

echo "[✓] MR3040 sekarang berfungsi sebagai Wi-Fi relay"
