FROM ubuntu:22.04
# for raspberryPi
#FROM hypriot/rpi-node

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install bluetooth
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install bluez
#for DEBUG
#RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install bluez-hcidump
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install libbluetooth-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install libudev-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install nodejs
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install npm

#FROM alpine:latest
# for raspberryPi
#FROM armhf/alpine
#RUN apk add --update alpine-sdk
#RUN apk add --update build-base
#RUN apk add python
#RUN apk add python-dev
#RUN apk add py-pip
#RUN pip install --upgrade pip
#RUN apk add bluez
#RUN apk add nodejs

COPY . /src
RUN cd /src; npm install
LABEL org.opencontainers.image.description RESTBLUE
LABEL org.opencontainers.image.source=https://github.com/datasance/restblue
LABEL org.opencontainers.image.licenses=EPL2.0

CMD ["node", "/src/index.js"]
#for DEBUG
#CMD ["/bin/sh", "/src/cmd.sh"]