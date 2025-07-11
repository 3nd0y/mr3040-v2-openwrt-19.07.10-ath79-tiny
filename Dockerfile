FROM debian:bullseye

# Install dependencies
RUN apt update && apt install -y \
  build-essential file libncurses-dev zlib1g-dev gawk git \
  gettext libssl-dev xsltproc rsync wget unzip tar python2 python3

# Unduh dan ekstrak Image Builder
RUN wget https://archive.openwrt.org/releases/19.07.10/targets/ath79/tiny/openwrt-imagebuilder-19.07.10-ath79-tiny.Linux-x86_64.tar.xz \
  && tar -xf openwrt-imagebuilder-19.07.10-ath79-tiny.Linux-x86_64.tar.xz \
  && rm openwrt-imagebuilder-19.07.10-ath79-tiny.Linux-x86_64.tar.xz

# Set direktori kerja
WORKDIR /openwrt-imagebuilder-19.07.10-ath79-tiny.Linux-x86_64

# Build image saat container dijalankan, lalu serve hasilnya
CMD make image PROFILE=tplink_tl-mr3040-v2 \
    PACKAGES="block-mount kmod-usb-core kmod-usb2 kmod-usb-storage kmod-fs-ext4 -ppp -ppp-mod-pppoe -firewall" \
  && cd bin/targets/ath79/tiny \
  && python3 -m http.server 8080
