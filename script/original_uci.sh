#!/bin/sh

echo "[+] Mengaktifkan IP Forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "[+] Flush aturan iptables lama..."
iptables -F
iptables -t nat -F
iptables -X

echo "[+] Memulihkan konfigurasi DHCP..."
uci batch <<EOF
delete dhcp
set dhcp.@dnsmasq[0]=dnsmasq
set dhcp.@dnsmasq[0].domainneeded='1'
set dhcp.@dnsmasq[0].boguspriv='1'
set dhcp.@dnsmasq[0].filterwin2k='0'
set dhcp.@dnsmasq[0].localise_queries='1'
set dhcp.@dnsmasq[0].rebind_protection='1'
set dhcp.@dnsmasq[0].rebind_localhost='1'
set dhcp.@dnsmasq[0].local='/lan/'
set dhcp.@dnsmasq[0].domain='lan'
set dhcp.@dnsmasq[0].expandhosts='1'
set dhcp.@dnsmasq[0].nonegcache='0'
set dhcp.@dnsmasq[0].authoritative='1'
set dhcp.@dnsmasq[0].readethers='1'
set dhcp.@dnsmasq[0].leasefile='/tmp/dhcp.leases'
set dhcp.@dnsmasq[0].resolvfile='/tmp/resolv.conf.auto'
set dhcp.@dnsmasq[0].localservice='1'
set dhcp.lan=dhcp
set dhcp.lan.interface='lan'
set dhcp.lan.start='100'
set dhcp.lan.limit='150'
set dhcp.lan.leasetime='12h'
set dhcp.lan.dhcpv6='server'
set dhcp.lan.ra='server'
set dhcp.wan=dhcp
set dhcp.wan.interface='wan'
set dhcp.wan.ignore='1'
set dhcp.odhcpd=odhcpd
set dhcp.odhcpd.maindhcp='0'
set dhcp.odhcpd.leasefile='/tmp/hosts/odhcpd'
set dhcp.odhcpd.leasetrigger='/usr/sbin/odhcpd-update'
EOF
uci commit dhcp

echo "[+] Mengembalikan konfigurasi firewall..."
cp /rom/etc/config/firewall /etc/config/firewall
/etc/init.d/firewall restart

echo "[+] Mengembalikan konfigurasi jaringan..."
uci batch <<EOF
set network.loopback=interface
set network.loopback.ifname='lo'
set network.loopback.proto='static'
set network.loopback.ipaddr='127.0.0.1'
set network.loopback.netmask='255.0.0.0'
set network.globals=globals
set network.globals.ula_prefix='fdbd:5cc0:9c94::/48'
set network.lan=interface
set network.lan.ifname='eth0'
set network.lan.force_link='1'
set network.lan.type='bridge'
set network.lan.proto='static'
set network.lan.ipaddr='192.168.1.1'
set network.lan.netmask='255.255.255.0'
set network.lan.ip6assign='60'
EOF
uci commit network
/etc/init.d/network restart

echo "[+] Mengembalikan konfigurasi wireless..."
uci batch <<EOF
set wireless.radio0=wifi-device
set wireless.radio0.type='mac80211'
set wireless.radio0.channel='11'
set wireless.radio0.hwmode='11g'
set wireless.radio0.path='platform/ar933x_wmac'
set wireless.radio0.htmode='HT20'
set wireless.radio0.disabled='1'
set wireless.@wifi-iface[0]=wifi-iface
set wireless.@wifi-iface[0].device='radio0'
set wireless.@wifi-iface[0].network='lan'
set wireless.@wifi-iface[0].mode='ap'
set wireless.@wifi-iface[0].ssid='OpenWrt'
set wireless.@wifi-iface[0].encryption='none'
EOF
uci commit wireless
wifi reload

echo "[+] Konfigurasi OpenWrt telah dipulihkan ke versi asli."
