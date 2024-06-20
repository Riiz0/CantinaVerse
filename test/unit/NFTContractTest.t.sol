// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Test, console2, Vm } from "forge-std/Test.sol";
import { NFTContract } from "../../src/NFTContract.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";

contract NFTContractTest is Test {
    NFTContract deployer;
    HelperConfig config;

    address MINTER = makeAddr("Minter");
    uint256 INITIAL_STARTING_BALABCE = 100 ether;

    event NewTokenMinted(address indexed to, uint256 indexed tokenId, string uri);

    function setUp() public {
        config = new HelperConfig();
        deployer = new NFTContract("TestNFT", "TNFT", "baseURI/", 100, address(config), 10);
        vm.deal(MINTER, INITIAL_STARTING_BALABCE);
    }

    function test() public { }
}
