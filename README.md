# oskarirauta/alpine-deluge-openvpn

![deluge](https://avatars2.githubusercontent.com/u/6733935?v=3&s=200) Deluge is a lightweight, Free Software, cross-platform BitTorrent client.

[deluge](http://deluge-torrent.org/) Deluge is a lightweight, Free Software, cross-platform BitTorrent client.

* OpenVPN
* Full Encryption
* WebUI
* Plugin System
* Much more...

## Usage

Deluge is started automaticly when OpenVPN connection has been initiated.

```
docker create \
  --name deluge \
  --net=host \
  -e PUID=<UID> -e PGID=<GID> \
  -e TZ=<timezone> \
  -v </path/to/your/downloads>:/downloads \
  -v </path/to/deluge/config>:/config \
  linuxserver/deluge
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `--net=host` - Shares host networking with container, **required**.
* `-v /config` - deluge configs
* `-v /downloads` - torrent download directory
* `-e PGID` for for GroupID - see below for explanation
* `-e PUID` for for UserID - see below for explanation
* `-e TZ` for timezone information, eg Europe/London

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it deluge /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application 

The admin interface is available at http://<ip>:8112 with a default user/password of admin/deluge.

To change the password (recommended) log in to the web interface and go to Preferences->Interface->Password.

Change the downloads location in the webui in Preferences->Downloads and use /downloads for completed downloads.

## Info

* Monitor the logs of the container in realtime `docker logs -f deluge`.

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' deluge`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/deluge`
