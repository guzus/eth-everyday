// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../EthEveryday.sol";

contract EthEverydayTest is Test {
    EthEveryday public collection;

    function setUp() public {
        collection = new EthEveryday();
    }

    function testMint() public {
        assertEqUint(collection.latest_mint_price(), 1e16);
        // should revert if minted twice
        collection.mint(address(this));
    }
}
