// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/MerkleProofUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract AppWorksV1 is
    Initializable,
    ERC721Upgradeable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable
{
    using StringsUpgradeable for uint256;

    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _nextTokenId;

    uint256 public price;
    uint256 public maxSupply;

    bool public mintActive;
    bool public earlyMintActive;
    bool public revealed;

    string public baseURI;
    string public blindBoxURI;
    bytes32 public merkleRoot;

    mapping(uint256 => string) private _tokenURIs;
    mapping(address => uint256) public addressMintedBalance;
    mapping(address => bool) public whitelistClaimed;

    function initialize() public initializer {
        price = 1 wei;
        maxSupply = 100;
        mintActive = false;
        earlyMintActive = false;
        revealed = false;

        __ERC721_init("AppWorks", "AW");
        __Ownable_init();
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    // Public mint function - week 8
    function mint(uint256 _mintAmount)
        public
        payable
        limitMintAmount(_mintAmount)
        nonReentrant
    {
        //Please make sure you check the following things:
        //Current state is available for Public Mint
        require(mintActive, "public mint not available");
        //Check how many NFTs are available to be minted
        require(
            _mintAmount <= maxSupply - totalSupply(),
            "mint amount invalid"
        );
        // Check _mintAmount greater than 0 and less than remaining amount
        require(_mintAmount > 0, "mint amount should greater than 0");
        //Check user has sufficient funds
        require(msg.value >= price * _mintAmount, "value not enough");

        // https://forum.openzeppelin.com/t/incrementing-counter-by-more-than-1/25781
        for (uint8 i = 0; i < _mintAmount; i++) {
            _nextTokenId.increment();
            uint256 newTokenId = _nextTokenId.current();
            _safeMint(msg.sender, newTokenId);
        }
    }

    // Implement totalSupply() Function to return current total NFT being minted - week 8
    function totalSupply() public view returns (uint256) {
        return _nextTokenId.current();
    }

    // Implement withdrawBalance() Function to withdraw funds from the contract - week 8
    function withdrawBalance() public onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "withdrawBalance error");
    }

    // Implement setPrice(price) Function to set the mint price - week 8
    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }

    // Implement toggleMint() Function to toggle the public mint available or not - week 8
    function toggleMint() public onlyOwner {
        mintActive = !mintActive;
    }

    // Set mint per user limit to 10 and owner limit to 20 - Week 8
    modifier limitMintAmount(uint256 _mintAmount) {
        if (msg.sender == owner()) {
            require(_mintAmount <= 20, "owner can't mint more than 20");
        } else {
            require(_mintAmount <= 10, "user can't mint more than 10");
        }

        _;
    }

    // Implement toggleReveal() Function to toggle the blind box is revealed - week 9
    function toggleReveal() public onlyOwner {
        revealed = !revealed;
    }

    // Implement setBaseURI(newBaseURI) Function to set BaseURI - week 9
    function setBaseURI(string memory newBaseURI) public onlyOwner {
        baseURI = newBaseURI;
    }

    // Function to return the base URI
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(tokenId <= totalSupply(), "token not exist");

        string memory mBaseURI = _baseURI();

        if (!revealed) {
            return blindBoxURI;
        }
        return
            bytes(mBaseURI).length > 0
                ? string(abi.encodePacked(mBaseURI, tokenId.toString()))
                : "";
    }

    // Early mint function for people on the whitelist - week 9
    function earlyMint(bytes32[] calldata _merkleProof, uint256 _mintAmount)
        public
        payable
        nonReentrant
    {
        //Please make sure you check the following things:
        //Current state is available for Early Mint
        require(earlyMintActive, "earlyMint not available");
        //Check how many NFTs are available to be minted
        require(
            _mintAmount <= maxSupply - totalSupply(),
            "mint amount invalid"
        );
        require(_mintAmount > 0, "mint amount should greater than 0");
        //Check user hasn't mint yet
        require(!whitelistClaimed[msg.sender], "Address already claimed");
        //Check user is in the whitelist - use merkle tree to validate
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProofUpgradeable.verify(_merkleProof, merkleRoot, leaf),
            "Invalid Merkle Proof"
        );
        //Check user has sufficient funds
        require(msg.value >= price * _mintAmount, "value not enough");

        for (uint8 i = 0; i < _mintAmount; i++) {
            _nextTokenId.increment();
            uint256 newTokenId = _nextTokenId.current();
            _safeMint(msg.sender, newTokenId);
        }

        whitelistClaimed[msg.sender] = true;
    }

    // Implement toggleEarlyMint() Function to toggle the early mint available or not - week 9
    function toggleEarlyMint() public onlyOwner {
        earlyMintActive = !earlyMintActive;
    }

    // Implement setMerkleRoot(merkleRoot) Function to set new merkle root - week 9
    function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
    }

    // Let this contract can be upgradable, using openzepplin proxy library - week 10
    // Try to modify blind box images by using proxy
    function setBlindBoxURI(string memory _blindBoxURI) public onlyOwner {
        blindBoxURI = _blindBoxURI;
    }
}
