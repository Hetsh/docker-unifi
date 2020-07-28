FROM library/debian:stretch-20200327-slim
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && \
    apt-get install --yes \
        binutils=2.28-5 \
        libcap2=1:2.25-1 \
        curl=7.52.1-5+deb9u11 \
        gnupg=2.1.18-8~deb9u4 \
        logrotate=3.11.0-0.1
RUN mkdir "/usr/share/man/man1" && \
    apt-get install --yes \
        openjdk-8-jre-headless=8u252-b09-1~deb9u1 \
        jsvc=1.0.15-7
ARG SSL_DEB="libssl.deb"
RUN curl -s --output "$SSL_DEB" --location "http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb" && \
    dpkg --install "$SSL_DEB" && \
    rm "$SSL_DEB"
RUN curl -s --location "https://www.mongodb.org/static/pgp/server-3.6.asc" | apt-key add - && \
    apt-get remove --yes gnupg && \
    echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.6 main" >> /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    apt-get update && \
    apt-get install --yes mongodb-org=3.6.18 && \
    apt-get autoremove --yes && \
    rm -r /var/lib/apt/lists /var/cache/apt

ARG UNIFI_PKG="unifi_sysvinit_all.deb"
ARG UNIFI_VERSION=5.13.29
ADD "https://dl.ubnt.com/unifi/$UNIFI_VERSION/$UNIFI_PKG" "$UNIFI_PKG"
RUN dpkg -i "$UNIFI_PKG" && \
    rm "$UNIFI_PKG"

ENTRYPOINT [ "sh" ]
