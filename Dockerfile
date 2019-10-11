FROM golang:1.13.1-alpine as build-container

# Set versions
ENV CAD_VER="v1.0.3"

# Set Needed Build flags
ENV GO111MODULE="on"

# Copy over the main file
COPY ./main.go /root/

# Build caddy
RUN apk add git && \
	cd ~ && \
	go mod init caddy && \
	go get github.com/caddyserver/caddy@${CAD_VER} && \
	go build

# Setup new container 
FROM alpine:3.10
RUN apk add -U --no-cache ca-certificates
COPY --from=build-container /root/caddy /opt/caddy

# Set container options
WORKDIR /opt
ENV CADDYPATH="/opt/.caddy"
CMD /opt/caddy -agree -log stdout -conf /opt/caddyfile
