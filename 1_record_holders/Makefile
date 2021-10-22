RPC_HOST ?= https://api.devnet.solana.com/
CHILL ?= 2

clean:
	@rm -fr build ../token_holders.log

install:
	@npm install

build/main.js: install
	@npm run build

fetch: build/main.js
	@node build/main.js --rpc-host=$(RPC_HOST) --chill=$(CHILL) | tee ../token_holders.log
