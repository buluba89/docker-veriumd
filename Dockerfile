FROM ubuntu:xenial

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libssl-dev \
    libdb++-dev \
    libboost-all-dev \
    libqrencode-dev \
    libcurl4-gnutls-dev \
    libminizip-dev \
    libminiupnpc-dev \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/* 

RUN git clone --depth 1 https://github.com/VeriumReserve/verium.git \
    && cd verium/src \
    && make -j 4 -f makefile.unix \
    && strip veriumd \
    && mv veriumd /usr/local/bin \
    && cd / \
    && rm -rf verium

RUN mkdir -p /data 

ADD start.sh .

VOLUME ["/data"]

EXPOSE 36987 36988

WORKDIR /data

HEALTHCHECK --start-period=5m --interval=2m --retries=10 CMD /usr/local/bin/veriumd -conf=/data/veriumd.conf getinfo || exit 1

LABEL maintainer="buluba89@gmail.com"
CMD ["/start.sh"]    

