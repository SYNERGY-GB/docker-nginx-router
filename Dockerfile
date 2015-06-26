FROM nginx
MAINTAINER Mariana Salcedo <mariana.salcedo@synergy-gb.com>

RUN apt-get update
RUN apt-get install curl -y

RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.6.0/confd-0.6.0-linux-amd64 -o confd

RUN mv confd /usr/local/bin/confd

RUN chmod +x /usr/local/bin/confd

RUN mkdir -p /etc/confd/{conf.d,templates}

ADD nginx.toml /etc/confd/conf.d/

ADD nginx.tmpl /etc/confd/templates/

ADD confd-watch /usr/local/bin/confd-watch

RUN chmod +x /usr/local/bin/confd-watch

RUN rm /etc/nginx/conf.d/default.conf

VOLUME /etc/ssl/nginx

ENTRYPOINT /usr/local/bin/confd-watch
