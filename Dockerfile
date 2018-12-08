FROM golang:1.11.2-alpine3.8 as build-container

ENV CAD_VER="v0.11.1"

RUN apk add -U git && \
    go get github.com/mholt/caddy/caddy && \
    go get github.com/caddyserver/builds && \
    cd $GOPATH/src/github.com/mholt/caddy/caddy && \
    git checkout tags/$CAD_VER && \
    go run build.go

FROM alpine:3.8

RUN apk add -U --no-cache ca-certificates
COPY --from=build-container /go/src/github.com/mholt/caddy/caddy/caddy /opt/caddy

WORKDIR /opt
CMD /opt/caddy -agree -conf /opt/caddyfile
