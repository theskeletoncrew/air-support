METAPLEX_PATH ?= "../metaplex"
KEY ?= "/Users/skeletoncrew/solana/skull-prod.json"
RPC_HOST ?= "https://api.devnet.solana.com/"
DROP ?= 1
TYPE ?= "token"

clean:
	@rm -f token_holders.log

burn:
	./0_burn_mistakes/burn.sh $(DROP) $(TYPE) $(RPC_HOST)

setup:
	mkdir -p ./airdrops/${DROP}

record: setup
	cd 1_record_holders && make fetch RPC_HOST=$(RPC_HOST)
	mv token_holders.log airdrops/$(DROP)/

generate: setup
	./2_generate_prints/mint.sh $(METAPLEX_PATH) $(KEY) $(MINT) $(DROP) $(NUM) $(TYPE) $(RPC_HOST)

choose:
	./3_choose_recipients/choose.sh $(DROP) $(NUM) $(TYPE) 

distribute:
	./4_distribute_nfts/distribute.sh $(DROP) $(TYPE) $(RPC_HOST)
