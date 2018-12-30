FROM golang:1.11.4-alpine3.8 as build-container

ENV CAD_VER="v0.11.1"

RUN apk add -U git && \
    go get github.com/mholt/caddy/caddy && \
    go get github.com/caddyserver/builds && \
    cd $GOPATH/src/github.com/mholt/caddy && \
    git checkout tags/$CAD_VER && \
    sed -i 's/var EnableTelemetry = true/var EnableTelemetry = false/g' caddy/caddymain/run.go && \
    sed -i 's/w.Header().Set("Server", caddy.AppName)//g' caddyhttp/httpserver/server.go && \
    cd caddy && \
    go run build.go

FROM alpine:3.8

RUN apk add -U --no-cache ca-certificates
COPY --from=build-container /go/src/github.com/mholt/caddy/caddy/caddy /opt/caddy

WORKDIR /opt
ENV CADDYPATH="/opt/.caddy"
CMD /opt/caddy -agree -log stdout -conf /opt/caddyfile
