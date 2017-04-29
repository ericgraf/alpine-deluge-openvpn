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
RUN groupmod -g 2001 users \
 && useradd -u 1001 -U -d /config -s /bin/false abc \
 && usermod -G users abc

RUN mkdir -p /etc/openvpn-new

# add local files
COPY root/ /
COPY openvpn/ /etc/openvpn-new/
