FROM ubuntu:20.04

MAINTAINER DuyHuynh <duyhuynh61@gmail.com>

WORKDIR /home/admin
ENV OPERATOR_NAME=Operator1
ENV ACCOUNT_NAME=Account1
ENV USER_NAME=User1

# install tools
RUN apt-get update \
&& apt-get install -y wget unzip \
&& apt-get install -y netcat tree

# install nats-server
RUN wget https://github.com/nats-io/nats-server/releases/download/v2.9.3/nats-server-v2.9.3-linux-amd64.tar.gz \
&& tar xzvf nats-server*.tar.gz \
&& cp nats-server-*/nats-server /usr/local/bin/ \
&& rm -rf nats-server*.tar.gz

# install nsc
RUN wget https://github.com/nats-io/nsc/releases/download/2.7.3/nsc-linux-amd64.zip  \
&& unzip -d nsc nsc-*.zip  \
&& cp nsc/nsc /usr/local/bin/ \
&& rm -rf nsc-*.zip

# install cli
RUN wget https://github.com/nats-io/natscli/releases/download/v0.0.34/nats-0.0.34-linux-amd64.zip  \
&& unzip -d nats nats-*.zip  \
&& cp nats/nats*/nats /usr/local/bin/ \
&& rm -rf nats-*.zip
 
COPY ./entrypoint.sh /home/admin/entrypoint.sh
RUN chmod u+x /home/admin/entrypoint.sh

EXPOSE 4222

ENTRYPOINT /bin/sh /home/admin/entrypoint.sh ${OPERATOR_NAME} ${ACCOUNT_NAME} ${USER_NAME}