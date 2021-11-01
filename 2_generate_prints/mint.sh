#!/bin/bash

METAPLEX_PATH=${1:-"../metaplex"}
KEYPAIR=$2
MINT_ADDRESS=$3
DROP=$4
NUM=$5
TYPE=${6:-"token"}
RPC_HOST=${7:-"https://api.devnet.solana.com/"}

OUTFILE_DIR="airdrops/${DROP}"

mkdir -p ${OUTFILE_DIR}

OUTFILE_FULL=${OUTFILE_DIR}/${TYPE}_detailed.log
OUTFILE_MINTS=${OUTFILE_DIR}/${TYPE}_mints.log

counter=1

while [ $counter -le ${NUM} ]
do

echo ""

echo "${METAPLEX_PATH}/rust/target/debug/metaplex-token-metadata-test-client \
  --keypair ${KEYPAIR} \
  mint_new_edition_from_master_edition_via_token \
  --mint ${MINT_ADDRESS} \
  --url ${RPC_HOST} \
  | tee -a ${OUTFILE_FULL}"

echo ""

${METAPLEX_PATH}/rust/target/debug/metaplex-token-metadata-test-client \
  --keypair ${KEYPAIR} \
  mint_new_edition_from_master_edition_via_token \
  --mint ${MINT_ADDRESS} \
  --url ${RPC_HOST} \
  | tee -a ${OUTFILE_FULL}

((counter=counter+1))

done

cat ${OUTFILE_FULL} | grep "Token mint: " | sed 's/Token mint: //' > ${OUTFILE_MINTS}

echo ""
echo "All done. Mint ids stored to ${OUTFILE_MINTS}"
