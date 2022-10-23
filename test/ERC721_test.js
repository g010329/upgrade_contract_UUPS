const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ERC721.sol", function () {
  async function deployFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Contract = await ethers.getContractFactory("NFT");
    const contract = await Contract.deploy();

    const d = await contract.price();
    console.log("contract", d);

    return { contract, owner, otherAccount };
  }

  describe("Deployment", async () => {
    it("Should set the right owner", async function () {
      const { contract, owner } = await loadFixture(deployFixture);

      expect(await contract.owner()).to.equal(owner.address);
    });

    it("Collection should set the right name", async function () {
      const { contract } = await loadFixture(deployFixture);

      expect(await contract.name()).to.equal("AppWorks");
    });

    it("Collection should have the right maxSupply", async function () {
      const { contract } = await loadFixture(deployFixture);

      expect(await contract.maxSupply()).to.equal("100");
    });

    it("mintActive should have the right status", async function () {
      const { contract } = await loadFixture(deployFixture);

      expect(await contract.mintActive()).to.equal(false);
    });

    it("earlyMintActive should have the right status", async function () {
      const { contract } = await loadFixture(deployFixture);

      expect(await contract.earlyMintActive()).to.equal(false);
    });
  });
  describe("Mint", async () => {
    it("Should revert with excess maximun number of mint", async function () {
      // const { contract } = await loadFixture(deployFixture);
      // await contract.toggleMint();
      // const price = await contract.price();
      // await expect(
      //   contract.mint(21, { value: price.mul(21) })
      // ).to.be.revertedWith("Excess maximun number of mint");
    });
  });
});
