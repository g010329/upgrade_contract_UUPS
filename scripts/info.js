// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.

const { ethers } = require("hardhat");

const PROXY_ADDRESS = "0x0A14151BA14412b88F4fd4F75C3682076Eb073b9";

async function main() {
  const NFT = await ethers.getContractFactory("AppWorksV1");
  const nft = NFT.attach(PROXY_ADDRESS);

  const owner = await nft.owner();
  console.log("owner:", owner);

  // 拿到 price，如果有正常 initialize 會是 1 wei
  const price = await nft.price();
  console.log("price:", price);

  // 拿到 notRevealedURI
  const blindBoxURI = await nft.blindBoxURI();
  blindBoxURI.length === 0
    ? console.log("blindBoxURI is empty")
    : console.log("blindBoxURI:", blindBoxURI);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
