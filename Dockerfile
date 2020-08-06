from ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
 apt-get -y upgrade && \
 apt-get install -y \
    locales \
    locales-all \
    openjdk-11-jre \
    openjdk-11-jdk \
    curl \
    ca-certificates \
    --no-install-recommends && \
 rm -fr /var/lib/apt/lists/* && \
 locale-gen en_US.UTF-8 && \
 echo 'LANG=en_US.UTF-8' > /etc/locale.conf && \
 useradd -m -s /bin/bash user

USER user
WORKDIR /home/user

RUN \
  export VERSION=$(curl -qsSL https://portswigger.net/burp/releases/community/latest 2>/dev/null | grep -Po -m 1 '(?<=version=)[^&]+' | tr -d '\n') && \
  curl -SL -o "burp.jar" "https://portswigger.net/burp/releases/download\?product\=community\&version\=${VERSION}\&type\=Jar"

COPY --chown=user:user ./project/ .

ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

CMD ["java", "-jar", "burp.jar", "--config-file=burp.proj.json", "--user-config-file=user.json"]
