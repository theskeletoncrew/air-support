#!/bin/bash

AIRDROP=$1
TYPE=$2
RPC_HOST=${3:-"https://api.mainnet-beta.solana.com/"}
STARTINDEX=${4:-0}

OUTFILE="airdrops/${1}/${TYPE}_sent.log"
TOKEN_LIST_FILE="airdrops/${AIRDROP}/${TYPE}_mints.log"
RECIPIENT_LIST_FILE="airdrops/${AIRDROP}/${TYPE}_addresses.log"

if [ ! -f ${TOKEN_LIST_FILE} ]; then
    echo "${TOKEN_LIST_FILE} not found! Run 'make generate' first."
    exit 1
fi

if [ ! -f ${RECIPIENT_LIST_FILE} ]; then
    echo "${RECIPIENT_LIST_FILE} not found! Run 'make choose' first."
    exit 1
fi

TOKEN_LIST=()
while IFS= read -r line; do
   TOKEN_LIST+=("$line")
done <${TOKEN_LIST_FILE}

RECIPIENT_LIST=()
while IFS= read -r line; do
   RECIPIENT_LIST+=("$line")
done <${RECIPIENT_LIST_FILE}

TOKEN_COUNT=${#TOKEN_LIST[@]}

for (( i=$STARTINDEX; i<${TOKEN_COUNT}; i++ ));
do
  TOKEN_MINT_ADDRESS=${TOKEN_LIST[$i]}
  RECIPIENT=${RECIPIENT_LIST[$i]}
  TOKEN_ACCOUNT_ADDRESS=$(spl-token accounts --output json | jq ".accounts[] | select(.mint==\"${TOKEN_MINT_ADDRESS}\") | .address" | sed s/\\\"//g)

  echo ""
  echo "${i}: spl-token transfer ${TOKEN_MINT_ADDRESS} 1 ${RECIPIENT} --from ${TOKEN_ACCOUNT_ADDRESS} --url ${RPC_HOST} --fund-recipient --allow-unfunded-recipient | tee ${OUTFILE}"
  echo ""

  spl-token transfer ${TOKEN_MINT_ADDRESS} 1 ${RECIPIENT} --from ${TOKEN_ACCOUNT_ADDRESS} --url ${RPC_HOST} --fund-recipient --allow-unfunded-recipient | tee ${OUTFILE} 
done

echo ""
echo "All done. Transactions stored to ${OUTFILE}"
