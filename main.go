package main

import (
	"github.com/caddyserver/caddy/caddy/caddymain"
	_ "github.com/caddyserver/dnsproviders/cloudflare"
	_ "github.com/nicolasazrak/caddy-cache"
)

func main() {
	caddymain.EnableTelemetry = false
	caddymain.Run()
}
