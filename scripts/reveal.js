// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.

const { ethers } = require("hardhat");

const PROXY_ADDRESS = "0x0A14151BA14412b88F4fd4F75C3682076Eb073b9";

async function main() {
  const NFTV2 = await ethers.getContractFactory("AppWorksV2");
  const nftV2 = await NFTV2.attach(PROXY_ADDRESS);

  await nftV2.toggleReveal();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
