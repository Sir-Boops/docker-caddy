FROM golang:1.11.4-alpine3.8 as build-container

# Set versions
ENV CAD_VER="v0.11.1"
ENV CAD_CAH="v0.3.1"

# Build caddy
RUN apk add -U git && \
	go get github.com/mholt/caddy/caddy && \
	go get github.com/caddyserver/builds && \
	go get github.com/caddyserver/dnsproviders/cloudflare && \
	go get github.com/nicolasazrak/caddy-cache && \
	cd $GOPATH/src/github.com/nicolasazrak/caddy-cache && \
	git checkout tags/$CAD_CAH && \
	cd $GOPATH/src/github.com/mholt/caddy && \
	git checkout tags/$CAD_VER && \
	sed -i 's/var EnableTelemetry = true/var EnableTelemetry = false/g' caddy/caddymain/run.go && \
	sed -i 's/w.Header().Set("Server", caddy.AppName)//g' caddyhttp/httpserver/server.go && \
	PLUG_NUM=`grep -n '// This is where other plugins get plugged in (imported)' caddy/caddymain/run.go | cut -f1 -d:` && \
	sed -i ''$PLUG_NUM'i _ "github.com/caddyserver/dnsproviders/cloudflare"' caddy/caddymain/run.go && \
	sed -i ''$PLUG_NUM'i _ "github.com/nicolasazrak/caddy-cache"' caddy/caddymain/run.go && \
	cat caddy/caddymain/run.go && \
	cd caddy && \
	go run build.go

FROM alpine:3.8

# Setup new container
RUN apk add -U --no-cache ca-certificates
COPY --from=build-container /go/src/github.com/mholt/caddy/caddy/caddy /opt/caddy

# Set container options
WORKDIR /opt
ENV CADDYPATH="/opt/.caddy"
CMD /opt/caddy -agree -log stdout -conf /opt/caddyfile
