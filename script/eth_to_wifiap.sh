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

echo "[+] Konfigurasi Wi-Fi sebagai Access Point..."
uci add wireless wifi-iface
uci set wireless.@wifi-iface[0]=wifi-iface
uci set wireless.@wifi-iface[0].device=radio0
uci set wireless.@wifi-iface[0].encryption=psk2
uci set wireless.@wifi-iface[0].key=fadli1987
uci set wireless.@wifi-iface[0].mode=ap
uci set wireless.@wifi-iface[0].network=lan
uci set wireless.@wifi-iface[0].ssid=Nexus-5
uci set wireless.radio0
uci set wireless.radio0.channel=auto
uci commit wireless
wifi reload

echo "[+] Atur alamat IP untuk AP..."
uci set network.lan
uci set network.lan.dns=8.8.8.8
uci set network.lan.ipaddr=192.168.10.1
uci commit network

echo "[+] Konfigurasi DHCP server untuk Wi-Fi..."
uci set dhcp.lan.interface='lan'
uci set dhcp.lan.start='100'
uci set dhcp.lan.limit='50'
uci set dhcp.lan.leasetime='12h'
uci set dhcp.lan.ra_management=1
uci commit dhcp
/etc/init.d/dnsmasq restart

echo "[✓] Mode AP aktif: Ethernet ➜ Wi-Fi Hotspot"
