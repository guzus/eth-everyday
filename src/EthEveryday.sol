// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";

contract EthEveryday is ERC1155 {
    uint256 public constant genesis_mint_price = 1e16;
    uint256 public latest_mint_price;
    address public deployer;
    mapping(uint256 => uint256) public mintCount;

    constructor() ERC1155("https://memtherscan.xyz/eth-everyday/{id}") {
        deployer = msg.sender;
        mint(msg.sender);
    }

    modifier onlyDeloyer {
        require(msg.sender == deployer, "Only deployer can call this function.");
        _;
    }

    function currentId() public view returns (uint256) {
        return block.timestamp / (24 * 60 * 60);
    }

    // if mint was done yesterday, increase mint price by 1.5x
    // else reset mint price to genesis_mint_price
    function mintPrice() public view returns (uint256) {
        if (mintCount[currentId()-1] > 0) {
            return latest_mint_price * 3 / 2;
        }
        return genesis_mint_price;
    }

    function mint(address account) public payable {
        uint256 id = currentId();
        require(mintCount[id] == 0, "already minted");
        require(msg.sender == deployer || msg.value >= mintPrice(), "Not enough ETH");
        _mint(account, id, 1, "");
        mintCount[id]++;
        latest_mint_price = mintPrice();
    }

    function changeBaseUri(string memory newuri) external onlyDeloyer {
        _setURI(newuri);
    }

    function withdraw() external onlyDeloyer {
        payable(deployer).transfer(address(this).balance);
    }
}