FROM library/debian:stretch-20200327-slim
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && \
    apt-get install --yes \
        binutils=2.28-5 \
        libcap2=1:2.25-1 \
        curl=7.52.1-5+deb9u10 \
        gnupg=2.1.18-8~deb9u4
RUN mkdir "/usr/share/man/man1" && \
    apt-get install --yes \
        openjdk-8-jre-headless=8u242-b08-1~deb9u1 \
        jsvc=1.0.15-7
RUN curl -s -L "https://www.mongodb.org/static/pgp/server-3.4.asc" | apt-key add - && \
    apt-get remove --yes gnupg && \
    echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" >> /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    apt-get update && \
    apt-get install --yes \
        libssl1.0.2=1.0.2u-1~deb9u1 \
        mongodb-org=3.4.24 \
        mongodb-org-server=3.4.24 \
        mongodb-org-shell=3.4.24 \
        mongodb-org-mongos=3.4.24 \
        mongodb-org-tools=3.4.24 && \
    apt-get autoremove --yes && \
    rm -r /var/lib/apt/lists /var/cache/apt

ARG UNIFI_DIR="/tmp"
ARG UNIFI_PKG="unifi_sysvinit_all.deb"
ARG UNIFI_VERSION=5.12.66
ADD "https://dl.ubnt.com/unifi/$UNIFI_VERSION/$UNIFI_PKG" "$UNIFI_DIR/$UNIFI_PKG"
RUN dpkg -i "$UNIFI_DIR/$UNIFI_PKG" && \
    rm "$UNIFI_DIR/$UNIFI_PKG"

CMD "sh"
