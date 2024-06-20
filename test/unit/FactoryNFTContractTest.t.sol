// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Test, console2, Vm } from "forge-std/Test.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { FactoryNFTContract } from "../../src/FactoryNFTContract.sol";

contract FactoryNFTContractTest is Test {
    HelperConfig config;
    FactoryNFTContract factory;

    address CREATOR = makeAddr("Creator");

    event CollectionCreated(
        address indexed collectionAddress,
        string indexed name,
        string indexed symbol,
        uint256 maxSupply,
        address owner,
        uint256 royaltyPercentage
    );

    function setUp() public {
        config = new HelperConfig();
        factory = new FactoryNFTContract(address(config));
    }

    function testSuccessfulCreateCollection() public {
        vm.prank(CREATOR);
        factory.createCollection("test", "tst", "ipfs://", 10, CREATOR, 10);

        assertEq(factory.getCollections().length, 1);
    }

    function testGetCollections() public {
        vm.prank(CREATOR);
        factory.createCollection("test", "tst", "ipfs://", 10, CREATOR, 10);
        address expectedAddress = factory.getCollections()[0];
        address[] memory collections = factory.getCollections();
        assertEq(collections.length, 1, "Should have exactly one collection");
        assertEq(expectedAddress, factory.getCollections()[0]);
    }
}
