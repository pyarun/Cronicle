FROM node:8.11-slim
LABEL maintainer="Arun Mittal - mittal.talk@gmail.com"

ARG PORT=80 
ARG HOSTNAME=${HOSTNAME}
ARG SERVER_TYPE=${SERVER_TYPE}

ENV DOCKERIZE_VERSION=v0.6.1 \
  HOSTNAME=${HOSTNAME} \
  PORT=${PORT} \
  EMAIL_FROM=mittal.talk@gmail.com \
  SMTP_HOSTNAME=10.253.1.76 \
  SERVER_TYPE=${SERVER_TYPE}

RUN \
  ## install dockerize
  wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz 

RUN mkdir -p /opt/cronicle
WORKDIR /opt/cronicle
ADD ./package.json /opt/cronicle/package.json
RUN npm install
COPY ./ /opt/cronicle
RUN node bin/build.js dist

#RUN cd /opt/cronicle && chmod +x -R bin/*.sh

EXPOSE ${PORT}

CMD [ "sh", "/opt/cronicle/bin/server.sh", "master" ]
