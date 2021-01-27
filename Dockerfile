FROM node as builder

RUN mkdir -p /src
WORKDIR /src

RUN git clone https://github.com/clustership/vue-todos.git \
    && cd vue-todos \
    && yarn install \
    && yarn build

# FROM registry.redhat.io/ubi8
FROM nginx

RUN apt-get update \
    && apt-get install -y libnss-wrapper \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY --from=builder /src/vue-todos/dist /usr/share/nginx/html
# USER 1001
# USER 1000
RUN chown -R 1000:0 /usr/share/nginx/html \
    && chmod g-rwx,o-rwx /usr/share/nginx/html \
    && mkdir -p /var/cache/nginx \
    && chown -R 1000:0 /etc/nginx/conf.d \
    && chmod g+rwx /etc/nginx/conf.d \
    && chown 1000:0 /var/cache/nginx \
    && chown 0:0 /var/run \
    && chmod g+rwx /var/run \
    && mkdir -p /home \
    && chown -R 1000:0 /home \
    && chmod 777 /home

COPY 99-change-listen-port.sh /docker-entrypoint.d/
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

USER 1000

CMD ["nginx", "-g", "daemon off;"]
