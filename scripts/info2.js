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
  const nftV2 = NFTV2.attach(PROXY_ADDRESS);

  const owner = await nftV2.owner();
  console.log("owner:", owner);

  // 拿到 price，如果有正常 initialize 會是 1 wei
  const price = await nftV2.price();
  console.log("price:", price);

  // 拿到 blindBoxURI
  const blindBoxURI = await nftV2.blindBoxURI();
  blindBoxURI.length === 0
    ? console.log("blindBoxURI is empty")
    : console.log("blindBoxURI:", blindBoxURI);

  // 拿到 totalSupply 數量
  const totalSupply = await nftV2.totalSupply();
  console.log("totalSupply:", totalSupply.toNumber());

  // 查看 mint出來的 tokenURI
  const tokenURIofIndex = await nftV2.tokenURI(1);
  console.log("tokenURIofIndex", tokenURIofIndex);

  // 拿到 public mint 狀態
  const mintActiveStatus = await nftV2.mintActive();
  console.log("mintActiveStatus:", mintActiveStatus);

  // 拿到 reveal 狀態
  const revealedStatus = await nftV2.revealed();
  console.log("revealedStatus:", revealedStatus);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
