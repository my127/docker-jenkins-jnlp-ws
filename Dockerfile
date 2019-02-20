FROM jenkins/jnlp-slave

USER root

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
 && apt-get auto-remove -qq -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install php7.2
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - \
 && echo 'deb https://packages.sury.org/php/ stretch main' > /etc/apt/sources.list.d/php.list \
 && apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
   php7.2-cli \
 && apt-get auto-remove -qq -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install my127/workspace
RUN wget https://github.com/my127/workspace/releases/download/0.1.0-beta.5/ws \
 && chmod +x ws \
 && mv ws /usr/local/bin/ws

# install docker client binary
RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-18.09.2.tgz \
  && tar -vzxf docker-18.09.2.tgz --strip=1 docker/docker \
  && rm -f docker-18.09.2.tgz \
  && mv docker /usr/local/bin/docker

# initialise ws utility
USER jenkins
RUN ws
