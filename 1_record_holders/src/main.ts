import { Connection, PublicKey } from "@solana/web3.js";
import { readFileSync } from "fs";
import { program } from "commander";
import pRetry from "p-retry";

program
  .version("0.0.1")
  .option(
    "-t, --token-address-log <string>",
    "token accounts",
    "../token-mint-addresses.json"
  )
  .option(
    "-e, --rpc-host <string>",
    "rpc host",
    "https://api.mainnet-beta.solana.com"
  )
  .option(
    "-c, --chill <number>",
    "sleep per token (please be nice to free rpc servers) ",
    "2"
  )
  .parse();

const { tokenAddressLog, rpcHost, chill } = program.opts();
const connection = new Connection(rpcHost, "singleGossip");

async function sleep(millis: number) {
  return new Promise((resolve) => setTimeout(resolve, millis));
}

async function mineCurrentHolder(
  tokenAccount: string
): Promise<string | undefined> {
  const largestAccounts = await connection.getTokenLargestAccounts(
    new PublicKey(tokenAccount)
  );
  const largestPDA = largestAccounts.value.shift();
  const largestWallet = await connection.getParsedAccountInfo(
    largestPDA?.address!
  );
  const data = largestWallet.value?.data.valueOf();

  //@ts-ignore
  return data?.parsed?.info?.owner;
}

async function main() {
  const mintList = JSON.parse(
    readFileSync(tokenAddressLog, 'utf8')
  ) as Array<string>;

  for await (const tokenAccount of mintList) {
    const currentHolder = await pRetry(
      async () => await mineCurrentHolder(tokenAccount),
      {
        onFailedAttempt: (err) =>
          console.error(`mining ${tokenAccount} failed.`, err),
        retries: 4,
      }
    );

    // Additions by the Skeleton Crew to ignore tokens held on marketplaces
    const digitalEyesMarket = "F4ghBzHFNgJxV4wEQDchU5i7n4XWWMBSaq7CuswGiVsr";
    const magicEdenMarket = "GUfCR9mK6azb9vcpsxgXyj7XRPAKJd4KMHTTVvtncGgp";
    const solanartMarket = "3D49QorJyNaL4rcpiynbuS3pRH4Y7EXEM6v6ZGaqfFGK";
    const alphaArtMarket = "4pUQS4Jo2dsfWzt3VgHXy3H6RYnEDd11oWPiaM2rdAPw";

    switch (currentHolder) {
      case digitalEyesMarket:
        break;
      case solanartMarket:
        break;
      case magicEdenMarket:
        break;
      case alphaArtMarket:
        break;
      default:
        console.log(currentHolder);
    }
    // End additions by the Skeleton Crew to ignore tokens held on marketplaces

    await sleep(parseInt(chill, 10));
  }
}

(async () => await main())();
