#!/bin/bash

DROP=$1
TYPE=$2
RPC_HOST=${3:-"https://api.devnet.solana.com/"}
STARTINDEX=${4:-0}

LISTFILENAME="${TYPE}_mints.log"
TOKEN_LIST_FILE=airdrops/${DROP}/${LISTFILENAME}

if [ ! -f ${TOKEN_LIST_FILE} ]; then
    echo "${TOKEN_LIST_FILE} not found! Nothing to burn."
    exit 1
fi

TOKEN_LIST=()
while IFS= read -r line; do
   TOKEN_LIST+=("$line")
done <${TOKEN_LIST_FILE}

TOKEN_COUNT=${#TOKEN_LIST[@]}

for (( i=$STARTINDEX; i<${TOKEN_COUNT}; i++ ));
do
  TOKEN_MINT_ADDRESS=${TOKEN_LIST[$i]}

  echo ""
  echo "spl-token accounts --output json --url $RPC_HOST | jq \".accounts[] | select(.mint==\\\"${TOKEN_MINT_ADDRESS}\\\") | .address\" | sed s/\\\"//g"

  TOKEN_ACCOUNT_ADDRESS=$(spl-token accounts --output json --url "${RPC_HOST}" | jq ".accounts[] | select(.mint==\"${TOKEN_MINT_ADDRESS}\") | .address" | sed s/\\\"//g)

  echo ""

  if [ -z "$TOKEN_ACCOUNT_ADDRESS" ]; then 
      echo "Could not find a token account for ${TOKEN_MINT_ADDRESS}"
      exit 1
  else 
      echo "${i}: spl-token burn ${TOKEN_ACCOUNT_ADDRESS} 1"
      spl-token burn ${TOKEN_ACCOUNT_ADDRESS} 1
  fi
done

echo "All tokens in ${TOKEN_LIST_FILE} burned."
