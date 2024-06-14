// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Test, console2, Vm } from "forge-std/Test.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { FactoryNFTContract } from "../../src/FactoryNFTContract.sol";

contract FactoryNFTContractTest is Test {
    HelperConfig config;
    FactoryNFTContract factory;

    address MINTER = makeAddr("Minter");

    event CollectionCreated(
        address indexed collectionAddress, string indexed name, string indexed symbol, uint256 maxSupply, address owner
    );

    function setUp() public {
        config = new HelperConfig();
        factory = new FactoryNFTContract(address(config));
    }

    function test() public { }
}
