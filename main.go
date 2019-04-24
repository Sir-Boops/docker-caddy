package main

import (
	_ "github.com/caddyserver/dnsproviders/cloudflare"
	"github.com/mholt/caddy/caddy/caddymain"
	_ "github.com/nicolasazrak/caddy-cache"
)

func main() {
	caddymain.EnableTelemetry = false
	caddymain.Run()
}
