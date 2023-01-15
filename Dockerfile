FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

ADD https://raw.githubusercontent.com/dceoy/print-github-tags/master/print-github-tags /usr/local/bin/print-github-tags

RUN set -e \
      && ln -sf bash /bin/sh

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        ca-certificates curl nginx \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -eo pipefail \
      && grep -n -e '^http {$' /etc/nginx/nginx.conf \
        | cut -d : -f 1 \
        | xargs -i expr 1 + {} \
        | xargs -i sed -ie '{}a \\tautoindex on;' /etc/nginx/nginx.conf \
      && rm -f /etc/nginx/nginx.confe

RUN set -eo pipefail \
      && chmod +x /usr/local/bin/print-github-tags \
      && v=$(print-github-tags --latest opentargets/ot-ui-apps) \
      && xargs curl -SL -o /tmp/bundle-platform.tgz \
        "https://github.com/opentargets/ot-ui-apps/releases/download/${v}/bundle-platform.tgz" \
      && xargs curl -SL -o /tmp/bundle-genetics.tgz \
        "https://github.com/opentargets/ot-ui-apps/releases/download/${v}/bundle-genetics.tgz" \
      && mkdir -p /opt/ot-ui-apps/platform /opt/ot-ui-apps/genetics \
      && tar xvf /tmp/bundle-platform.tgz -C /opt/ot-ui-apps/platform/ --remove-files \
      && tar xvf /tmp/bundle-genetics.tgz -C /opt/ot-ui-apps/genetics/ --remove-files

RUN set -e \
      && rm -rf /var/www/html \
      && ln -s /opt/ot-ui-apps /var/www/html \
      && ln -sf /dev/stdout /var/log/nginx/access.log \
      && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

ENTRYPOINT ["/usr/sbin/nginx"]
CMD ["-g", "daemon off;"]
