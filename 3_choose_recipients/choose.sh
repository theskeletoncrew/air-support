#!/bin/bash

DROP=$1
NUM=$2
TYPE=${3:-"token"}

DIR=airdrops/${DROP}
TOKEN_HOLDERS=${DIR}/token_holders.log

if [ ! -f ${TOKEN_HOLDERS} ]; then
    echo "${TOKEN_HOLDERS} not found! Run 'make record' first."
    exit 1
fi

echo "Choosing recipients for airdrop $1 in ${DIR}"
gshuf ${TOKEN_HOLDERS} | head -n ${NUM} > ${DIR}/${TYPE}_addresses.log
