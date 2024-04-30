FROM ubuntu:20.04 as etcdbase
LABEL function=etcd

ARG ETCD_VER=v3.4.32

ARG GOOGLE_URL=https://storage.googleapis.com/etcd
ARG GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
ARG DOWNLOAD_URL=https://storage.googleapis.com/etcd

ARG ETCD_NODE_NAME=default
ARG PEER_ADVERTISE
ARG CLIENT_ADVERTISE
ARG CLUSTER_NAME
ARG CLUSTER_VERSION

EXPOSE 2379/tcp
EXPOSE 2380/tcp

RUN mkdir -p /data && mkdir -p /opt/etcd
VOLUME [ "/data" ]
ENV ETCD_DATA_DIR=/data

RUN apt update \
    && apt -y install wget curl ca-certificates

RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq \
    && chmod +x /usr/bin/yq

RUN rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz \
    && rm -rf /tmp/etcd-download-test \
    && mkdir -p /tmp/etcd-download-test

RUN curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz \
    && tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /opt/etcd --strip-components=1 \
    && rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

COPY ca/ca/ca.crt /opt/etcd/ca.crt
RUN cp /opt/etcd/ca.crt /usr/local/share/ca-certificates \
    && update-ca-certificates

COPY ca/ca/$CLUSTER_NAME$CLUSTER_VERSION/$ETCD_NODE_NAME.vmnet.arpa/private.key /opt/etcd/private.key
COPY ca/ca/$CLUSTER_NAME$CLUSTER_VERSION/$ETCD_NODE_NAME.vmnet.arpa/public.crt /opt/etcd/public.crt

COPY etcd/etcd.conf /opt/etcd/etcd.conf
RUN yq -i '.name = $ETCD_NODE_NAME' /opt/etcd/etcd.conf \
    && yq -i '.initial-advertise-peer-urls = $PEER_ADVERTISE' /opt/etcd/etcd.conf \
    && yq -i '.advertise-client-urls = $CLIENT_ADVERTISE' /opt/etcd/etcd.conf

ENTRYPOINT ["/opt/etcd/etcd", "--config-file", "/opt/etcd/etcd.conf"]






