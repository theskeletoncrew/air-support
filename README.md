![air-support](https://user-images.githubusercontent.com/89115113/138522903-0f13fa38-7f84-493c-ac34-f9768f35a8fb.png)

# Air Support: Tools for Automating Airdrops of Solana NFTs

[The Skeleton Crew](https://skeletoncrew.rip) | Twitter: [@skeletoncrewrip](https://twitter.com/skeletoncrewrip) |  Discord: [Skeleton Crew](https://discord.gg/skeletoncrewrip)

Feeling generous? Your contributions help fund future development.  
Send tips to our Solana wallet: CH6afYjjydFLPSrfQYEUNCdSNohLCAQV6ir6QnYeZU3t  

_See also: [Treat Toolbox](https://github.com/theskeletoncrew/treat-toolbox), a generative art manager for NFT projects from the Skeleton Crew._


# Background

The Skeleton Crew launched on Oct 1, and has since been delivering daily airdrops of artwork from indie artists, with plans to continue for the entire month of October.

In order to execute on this plan, we needed tools that allowed us to automate the process. This repository is the result of that effort, which we now share with you in the hopes of more teams spending less time giving themselves Carpal tunnel syndrome doing all of this manually inside of Phantom :)  


# IMPORTANT - Before you Start

Creating and sending NFTs in bulk comes with costs. On Solana, the costs are significantly better than some other chains. BUT, it's a good idea to try a drop on devnet first to be sure you understand the fees involved. We assume no responsibility for any costs incurred through the use of these tools. Use at your own risk.  


# Getting Started

In order to use Air Support, you will need to install and configure the current version of [Metaplex](https://github.com/metaplex-foundation/metaplex). We run this locally with some customizations for speed (ex. hardcoding some metadata which is common across all of our drops).  

Also, have a look at the configuration options at the top of the `Makefile`. At minimum, you'll need to specify paths to Metaplex, your keyfile, and an RPC Host. It's highly recommended that you use a third-party RPC provider to perform large airdrops. DROP is a name for a set of airdrops; in our case we numbered these 1-31 for each day in October. TYPE is a name for a single airdropped item that's part of a drop; in our case we had a "trick" and a "treat" as part of each drop, sometimes even "trick1", "trick2"... etc. The name will be "token" by default, and is used to prefix log files in each step below.  

For the generate step to work, you will need to build Metaplex's rust tools. Inside `metaplex/rust`, run:

```bash
cargo build
```

You will also need a few other pieces of software installed, including: 
- gshuf: `brew install coreutils`
- jq: `brew install jq`


# How to Use Air Support

Prerequisites: follow all steps in the Getting Started section above.

Then, the basic workflow looks something like this:  

📇 **prepare**: Collect a list of token mint addresses, for which the holders of those tokens represent a community you wish to airdrop to. This is sometimes done by providing your Candy Machine address to https://tools.abstratica.art. Store this in the air support root directory as `token-mint-addresses.log`.   
  
  
✍️ **record**: run this to fetch the wallet addresses of all users that hold the tokens, and don't have them listed on a secondary exchange. The goal here is to avoid sending airdrops to exchanges where they may not be recoverable. Note: As of now, Air Support can only identify tokens listed on Digital Eyes, Magic Eden, Solanart, and Alpha.art. FTX and Solsea use unique addresses for escrow wallets. The command below will fetch the addresses and store them in `airdrops/1/token-holders.log`.  
  
  ```bash
  make record DROP=1
  ```  
  
  
🎨 **create**: Start Metaplex, and use it to create your Master Edition NFT with a limited supply (the number of airdrops you want to send).  
  
  ```bash
  cd metaplex/js && yarn start
  ```
  
🖨 **generate**: run this to generate prints of the Master Edition. These will be stored in the wallet associated with the keys you specify as options. The below command would create 500 prints of the Master with mint address RPdCMRxBx4YPcJv6HUb2S5zHGJcDrDrZszUNNGmLwfT.  
  
  ```bash
  make generate MINT=RPdCMRxBx4YPcJv6HUb2S5zHGJcDrDrZszUNNGmLwfT NUM=500
  ```  
  
  
🏅 **choose**: run this next to decide who will receive the airdrop. Important to note that if 2 tokens are owned by the same wallet, by design they have twice the chance to receive an airdrop as someone with only 1 token when using this script to pick recipients. If you have 10,000 token owners recorded as not listed on marketplaces in step 2, and 500 airdrops to send, this will randomly select 500 of those recorded tokens.  
  
  ```bash
  make choose NUM=500
  ```  
  
  
📬 **distribute**: the last step is to send the airdrops out. This script will run through the addresses generated in step 4 and the recipients chosen in step 5 and send airdrops 1-by-1. It is possible that failures will occur. Logs are saved during the process in a `{NAME}_sent.log` file. Because distribution happens line-by-line, it is safe to rerun the script again to attempt to correct failures. You can also check your wallet to see that all tokens have been distributed. (Note that your Master edition will still remain as only prints are recorded to be sent in step 4. You can keep these for yourself or a community vault.) There is also an optional `STARTINDEX` param that can be used if you need to restart a distribution from somewhere in the middle.  
  
  ```bash
  make distribute
  ```  
  
  
🔥 **burn**: if you realize you made a mistake on your Master NFT, but only after you went ahead and started printing a bunch of editions, this command will automate the process of sending those costly mistakes to the Solana incinerator. There is also an optional `STARTINDEX` param that can be used if you need to restart a distribution from somewhere in the middle.  
  
  ```bash
  make burn
  ```  
  

# Other Tips

Transparency is key when running airdrop campaigns to your communities. In an ideal world, where we had more than 24 hours between our launch and the start of our month of airdrops, we might have attempted to bring some or all of these processes **on-chain**.  
  
The next best thing we could offer is a transparency repo, where we publish the daily receipts of our airdrops, to make it easy for our community to investigate the drops on the blockchain if they feel the desire to do so. Our tools give you the receipts as output to do the same if you wish.  
  
You can have a look at that repo here: 
https://github.com/theskeletoncrew/airdrop-transparency  
  
  
# Acknowledgements
  
The `record` step utilizes code created by the Exiled Apes organization, shared under an Apache License, originally found here: https://github.com/exiled-apes/exiled-holders  
