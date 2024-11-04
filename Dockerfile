FROM fedora:rawhide

WORKDIR /opt

# Make directories
RUN mkdir -p /downloads /config/qBittorrent /etc/openvpn /etc/qbittorrent

# Install dependencies
RUN dnf install -y \
    dos2unix \
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
