FROM node:9.11.1-wheezy
ARG INSTANT_CLIENT_VERSION=11.2.0.4.0

RUN apt-get update \
 && apt-get install -y libaio1 \
 && apt-get install -y build-essential \
 && apt-get install -y unzip \
 && apt-get install -y curl

RUN mkdir -p opt/oracle
ADD ./linux/ .

RUN unzip instantclient-basic-linux.x64-$INSTANT_CLIENT_VERSION.zip -d /opt/oracle \
 && unzip instantclient-sdk-linux.x64-$INSTANT_CLIENT_VERSION.zip -d /opt/oracle  \
 && mv /opt/oracle/instantclient_11_2 /opt/oracle/instantclient \
 && ln -s /opt/oracle/instantclient/libclntsh.so.11.1 /opt/oracle/instantclient/libclntsh.so \
 && ln -s /opt/oracle/instantclient/libocci.so.11.1 /opt/oracle/instantclient/libocci.so

ENV LD_LIBRARY_PATH="/opt/oracle/instantclient"
ENV OCI_HOME="/opt/oracle/instantclient"
ENV OCI_LIB_DIR="/opt/oracle/instantclient"
ENV OCI_INCLUDE_DIR="/opt/oracle/instantclient/sdk/include"
ENV OCI_VERSION=11

RUN echo '/opt/oracle/instantclient/' | tee -a /etc/ld.so.conf.d/oracle_instant_client.conf && ldconfig
