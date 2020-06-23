FROM debian:stable-slim

RUN mkdir -p /root/.ssh

RUN  apt-get update \
  && apt-get install -y wget openssh-client git

RUN wget https://github.com/splitsh/lite/releases/download/v1.0.1/lite_linux_amd64.tar.gz -O /tmp/lite_linux_amd64.tar.gz
RUN tar -zxpf /tmp/lite_linux_amd64.tar.gz --directory /usr/local/bin
RUN chmod +x /usr/local/bin/splitsh-lite

COPY split.sh /usr/local/bin/split
RUN chmod +x /usr/local/bin/split

CMD ["split"]
