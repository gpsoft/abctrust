FROM alpine:3.6
RUN apk update && apk add openssl

RUN mkdir -p /tmp/work
WORKDIR /tmp/work

COPY issue.sh .
COPY openssl.cnf .
