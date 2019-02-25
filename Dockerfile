FROM php:7.2-cli-stretch

# apply updates and install package depdendencies
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -s dist-upgrade | grep "^Inst" | \
      grep -i securi | awk -F " " '{print $2}' | \
      xargs apt-get -qq -y --no-install-recommends install \
 \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
   apt-transport-https \
   git \
   awscli \
 && apt-get auto-remove -qq -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install my127/workspace
RUN curl -L -o ws https://github.com/my127/workspace/releases/download/0.1.0-beta.6/ws \
 && chmod +x ws \
 && mv ws /usr/local/bin/ws

# install docker client binary
RUN curl -L -o docker-18.09.2.tgz https://download.docker.com/linux/static/stable/x86_64/docker-18.09.2.tgz \
  && tar -vzxf docker-18.09.2.tgz --strip=1 docker/docker \
  && rm -f docker-18.09.2.tgz \
  && mv docker /usr/local/bin/docker

# initialise ws utility
RUN ws
