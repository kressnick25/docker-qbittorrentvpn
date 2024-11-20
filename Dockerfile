FROM fedora:41

LABEL org.opencontainers.image.source=https://github.com/kressnick25/docker-qbittorrentvpn

WORKDIR /opt

# Make directories
RUN mkdir -p /downloads /config/qBittorrent /etc/openvpn /etc/qbittorrent

# Install dependencies
RUN dnf install -y \
    dos2unix \
    ipcalc \
    iptables-nft \
    iptables-legacy \
    openvpn \
    qbittorrent-nox \
    start-stop-daemon \
    unrar \
    unzip \
    wireguard-tools \
    zip \
    ifconfig \
    ts \
    redhat-lsb \
    initscripts \
    iproute \
    iputils \
    && dnf clean all

VOLUME /config /downloads

ADD openvpn/ /etc/openvpn/
ADD qbittorrent /etc/qbittorrent

RUN chmod +x /etc/qbittorrent/*.sh /etc/qbittorrent/*.init /etc/openvpn/*.sh

EXPOSE 8080
EXPOSE 8999
EXPOSE 8999/udp

CMD ["/bin/bash", "/etc/openvpn/start.sh"]
