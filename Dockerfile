FROM oskarirauta/alpine:latest
MAINTAINER Oskari Rauta <oskari.rauta@gmail.com>

# Environment variables
ENV PYTHON_EGG_CACHE="/config/plugins/.python-eggs"
ENV OPENVPN_USERNAME=**None**
ENV OPENVPN_PASSWORD=**None**
ENV OPENVPN_PROVIDER=**None**
ENV PUID=1001
ENV PGID=2001

# Volumes
VOLUME /config
VOLUME /data

# Exposed ports
EXPOSE 8112 58846 58946 58946/udp

# Install runtime packages
RUN \
 apk add --no-cache \
	ca-certificates \
	p7zip \
	unrar \
	unzip \
	shadow \
 && apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/main \
	libressl2.5-libssl \
 && apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/testing \
	deluge

# install openvpn
RUN apk add --no-cache openvpn
 
# Install build packages
RUN apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	libffi-dev \
	libressl-dev \
	py2-pip \
	python2-dev

# install pip packages
RUN pip install --no-cache-dir -U \
	incremental \
	pip \
 && pip install --no-cache-dir -U \
	crypto \
	mako \
	markupsafe \
	pyopenssl \
	service_identity \
	six \
	twisted \
	zope.interface

# cleanup
RUN apk del --purge build-dependencies \
 && rm -rf /root/.cache

# Create user and group
RUN addgroup -S -g 2001 media
RUN adduser -SH -u 1001 -G media -s /sbin/nologin -h /config deluge

# add local files and replace init script
RUN rm /etc/init.d/openvpn
COPY root/ /
COPY openvpn/ /etc/openvpn/
COPY init/openvpn /etc/init.d/openvpn
COPY init/deluged /etc/init.d/deluged
COPY init/deluge-web /etc/init.d/deluge-web

RUN chmod +x /etc/init.d/openvpn \
 && chmod +x /etc/init.d/deluged \
 && chmod +x /etc/init.d/deluge-web

RUN chmod +x /etc/openvpn/deluge-up.sh \
 && chmod +x /etc/openvpn/deluge-down.sh
 
