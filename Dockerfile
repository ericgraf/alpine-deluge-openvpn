FROM oskarirauta/alpine:latest
MAINTAINER Oskari Rauta <oskari.rauta@gmail.com>

# environment variables
ENV PYTHON_EGG_CACHE="/config/plugins/.python-eggs"
ENV OPENVPN_USERNAME=**None**
ENV OPENVPN_PASSWORD=**None**
ENV OPENVPN_PROVIDER=**None**
ENV PUID=1001
ENV PGID=2001

# install runtime packages
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
	deluge \
# install openvpn
 && apk add --no-cache openvpn \
 
# install build packages
 && apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	libffi-dev \
	libressl-dev \
	py2-pip \
	python2-dev \

# install pip packages
 && pip install --no-cache-dir -U \
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
	zope.interface \

# cleanup
 && apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8112 58846 58946 58946/udp

VOLUME /config
VOLUME /data
