FROM php:7.4-cli-alpine
ARG WS_VERSION
ARG HELM_VERSION=2.16.7

RUN apk add --no-cache aws-cli docker-cli bash docker-compose git openssh-client jq rsync

RUN set -ex \
    # helm
    && wget -O helm.tar.gz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    && tar -C /usr/local/bin --strip-components=1 -zxvf helm.tar.gz "linux-amd64/helm" \
    && rm ./helm.tar.gz \
    # kubeseal
    && wget -O /usr/local/bin/kubeseal https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.12.5/kubeseal-linux-amd64 \
    && chmod +x /usr/local/bin/kubeseal \
    # workspace
    && wget -O /usr/local/bin/ws "https://github.com/my127/workspace/releases/download/${WS_VERSION}/ws" \
    && chmod +x /usr/local/bin/ws

ENTRYPOINT [ "/usr/local/bin/ws" ]
