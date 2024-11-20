# [qBittorrent](https://github.com/qbittorrent/qBittorrent) and OpenVPN

Docker container which runs the latest [qBittorrent](https://github.com/qbittorrent/qBittorrent)-nox client while connecting to OpenVPN with iptables killswitch to prevent IP leakage when the tunnel goes down.

[preview]: https://raw.githubusercontent.com/DyonR/docker-templates/master/Screenshots/qbittorrentvpn/qbittorrentvpn-webui.png "qBittorrent WebUI"

![alt text][preview]

# Docker Features

-   Base: Fedora Rawhide
-   [qBittorrent](https://github.com/qbittorrent/qBittorrent)
-   IP tables killswitch to prevent IP leaking when VPN connection fails
-   Configurable UID and GID for config files and /downloads for qBittorrent
-   BitTorrent port 8999 exposed by default

## Run container from Docker registry

The container is available from the Docker registry and this is the simplest way to get it  
To run the container use this command, with additional parameters, please refer to the Variables, Volumes, and Ports section:

```
$ docker run  -d \
              -v /your/config/path/:/config \
              -v /your/downloads/path/:/downloads \
              -e "VPN_ENABLED=yes" \
              -e "VPN_TYPE=openvpn" \
              -e "LAN_NETWORK=192.168.0.0/24" \
              -p 8080:8080 \
              --cap-add NET_ADMIN \
              --sysctl "net.ipv4.conf.all.src_valid_mark=1" \
              --restart unless-stopped \
              ghcr.io/kressnick25/qbittorrent-vpn:latest
```

## Docker Tags

| Tag                                          | Description                                             |
| -------------------------------------------- | ------------------------------------------------------- |
| `ghcr.io/kressnick25/qbittorrent-vpn:latest` | The latest version of qBittorrent with libtorrent 2_x_x |

# Variables, Volumes, and Ports

## Environment Variables

| Variable                | Required          | Function                                                                                                               | Example                                   | Default           |
| ----------------------- | ----------------- | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- | ----------------- |
| `VPN_ENABLED`           | Yes               | Enable VPN (yes/no)?                                                                                                   | `VPN_ENABLED=yes`                         | `yes`             |
| `VPN_TYPE`              | Yes               | OpenVPN (openvpn)?                                                                                                     | `VPN_TYPE=openvpn`                        | `openvpn`         |
| `VPN_USERNAME`          | No                | If username and password provided, configures ovpn file automatically                                                  | `VPN_USERNAME=ad8f64c02a2de`              |                   |
| `VPN_PASSWORD`          | No                | If username and password provided, configures ovpn file automatically                                                  | `VPN_PASSWORD=ac98df79ed7fb`              |                   |
| `LAN_NETWORK`           | Yes (atleast one) | Comma delimited local Network's with CIDR notation                                                                     | `LAN_NETWORK=192.168.0.0/24,10.10.0.0/24` |                   |
| `LEGACY_IPTABLES`       | No                | Use `iptables (legacy)` instead of `iptables (nf_tables)`                                                              | `LEGACY_IPTABLES=yes`                     |                   |
| `ENABLE_SSL`            | No                | Let the container handle SSL (yes/no)?                                                                                 | `ENABLE_SSL=yes`                          | `yes`             |
| `NAME_SERVERS`          | No                | Comma delimited name servers                                                                                           | `NAME_SERVERS=1.1.1.1,1.0.0.1`            | `1.1.1.1,1.0.0.1` |
| `PUID`                  | No                | UID applied to /config files and /downloads                                                                            | `PUID=99`                                 | `99`              |
| `PGID`                  | No                | GID applied to /config files and /downloads                                                                            | `PGID=100`                                | `100`             |
| `UMASK`                 | No                |                                                                                                                        | `UMASK=002`                               | `002`             |
| `HEALTH_CHECK_HOST`     | No                | This is the host or IP that the healthcheck script will use to check an active connection                              | `HEALTH_CHECK_HOST=one.one.one.one`       | `one.one.one.one` |
| `HEALTH_CHECK_INTERVAL` | No                | This is the time in seconds that the container waits to see if the internet connection still works (check if VPN died) | `HEALTH_CHECK_INTERVAL=300`               | `300`             |
| `HEALTH_CHECK_SILENT`   | No                | Set to `1` to supress the 'Network is up' message. Defaults to `1` if unset.                                           | `HEALTH_CHECK_SILENT=1`                   | `1`               |
| `HEALTH_CHECK_AMOUNT`   | No                | The amount of pings that get send when checking for connection.                                                        | `HEALTH_CHECK_AMOUNT=10`                  | `1`               |
| `RESTART_CONTAINER`     | No                | Set to `no` to **disable** the automatic restart when the network is possibly down.                                    | `RESTART_CONTAINER=yes`                   | `yes`             |
| `INSTALL_PYTHON3`       | No                | Set this to `yes` to let the container install Python3.                                                                | `INSTALL_PYTHON3=yes`                     | `no`              |
| `ADDITIONAL_PORTS`      | No                | Adding a comma delimited list of ports will allow these ports via the iptables script.                                 | `ADDITIONAL_PORTS=1234,8112`              |                   |

## Volumes

| Volume      | Required | Function                                    | Example                            |
| ----------- | -------- | ------------------------------------------- | ---------------------------------- |
| `config`    | Yes      | qBittorrent and OpenVPN config files        | `/your/config/path/:/config`       |
| `downloads` | No       | Default downloads path for saving downloads | `/your/downloads/path/:/downloads` |

## Ports

| Port   | Proto | Required | Function                       | Example         |
| ------ | ----- | -------- | ------------------------------ | --------------- |
| `8080` | TCP   | Yes      | qBittorrent WebUI              | `8080:8080`     |
| `8999` | TCP   | Yes      | qBittorrent TCP Listening Port | `8999:8999`     |
| `8999` | UDP   | Yes      | qBittorrent UDP Listening Port | `8999:8999/udp` |

# Access the WebUI

Access https://IPADDRESS:PORT from a browser on the same network. (for example: https://192.168.0.90:8080)

## Default Credentials

| Credential | Default Value |
| ---------- | ------------- |
| `username` | `admin`       |
| `password` | {check logs}  |

# How to use OpenVPN

The container will fail to boot if `VPN_ENABLED` is set and there is no valid .ovpn file present in the /config/openvpn directory. Drop a .ovpn file from your VPN provider into /config/openvpn (if necessary with additional files like certificates) and start the container again. You may need to edit the ovpn configuration file to load your VPN credentials from a file by setting `auth-user-pass`.

**Note:** The script will use the first ovpn file it finds in the /config/openvpn directory. Adding multiple ovpn files will not start multiple VPN connections.

## Example auth-user-pass option for .ovpn files

`auth-user-pass credentials.conf`

## Example credentials.conf

```
username
password
```

## PUID/PGID

User ID (PUID) and Group ID (PGID) can be found by issuing the following command for the user you want to run the container as:

```
id <username>
```

### Credits:

[ds-exe/docker-qBittorentvpn](https://github.com/ds-exe/docker-qbittorrentvpn)  
[DyonR/docker-qBittorrentvpn](https://github.com/DyonR/docker-qbittorrentvpn)  
[MarkusMcNugen/docker-qBittorrentvpn](https://github.com/MarkusMcNugen/docker-qBittorrentvpn)  
[DyonR/jackettvpn](https://github.com/DyonR/jackettvpn)  
This projects originates from DyonR/docker-qBittorrentvpn
