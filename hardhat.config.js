require("@nomicfoundation/hardhat-toolbox");
require("@openzeppelin/hardhat-upgrades");

// TODO: Add your own private key here
const privateKey = "";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      // TODO: Add your own Naas provider here
      url: "",
      accounts: [privateKey],
    },
  },
  etherscan: {
    apiKey: {
      // TODO: Add your own Etherscan API key here
      goerli: "",
    },
  },
};
