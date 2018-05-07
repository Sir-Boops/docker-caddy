FROM golang:1.10.2-alpine3.7 as build-container

ENV CAD_VER="v0.10.14"

RUN addgroup caddy && \
    adduser -D -h /opt -G caddy caddy && \
    echo "caddy:`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 | mkpasswd -m sha256`" | chpasswd

RUN apk add -U git && \
    go get github.com/mholt/caddy/caddy && \
    go get github.com/caddyserver/builds && \
    cd $GOPATH/src/github.com/mholt/caddy/caddy && \
    git checkout tags/$CAD_VER && \
    go run build.go

FROM alpine:3.7

RUN apk add -U --no-cache ca-certificates
COPY --from=build-container /go/src/github.com/mholt/caddy/caddy/caddy /opt/caddy

CMD /opt/caddy -http-port 8080 -https-port 4443
