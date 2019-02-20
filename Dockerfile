FROM php:7.2-cli-stretch

# install my127/workspace
RUN curl -L -o ws https://github.com/my127/workspace/releases/download/0.1.0-beta.5/ws \
 && chmod +x ws \
 && mv ws /usr/local/bin/ws

# install docker client binary
RUN curl -L -o docker-18.09.2.tgz https://download.docker.com/linux/static/stable/x86_64/docker-18.09.2.tgz \
  && tar -vzxf docker-18.09.2.tgz --strip=1 docker/docker \
  && rm -f docker-18.09.2.tgz \
  && mv docker /usr/local/bin/docker

# initialise ws utility
RUN ws
