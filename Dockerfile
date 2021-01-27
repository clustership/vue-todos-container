FROM node as builder

RUN mkdir -p /src
WORKDIR /src

RUN git clone https://github.com/clustership/vue-todos.git \
    && cd vue-todos \
    && yarn install \
    && yarn build

# FROM registry.redhat.io/ubi8
FROM nginx


COPY --from=builder /src/vue-todos/dist /usr/share/nginx/html
