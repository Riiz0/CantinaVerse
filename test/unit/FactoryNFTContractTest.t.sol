// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Test, console2, Vm } from "forge-std/Test.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { FactoryNFTContract } from "../../src/FactoryNFTContract.sol";
import { DeployFactoryNFTContract } from "../../script/DeployFactoryNFTContract.s.sol";

contract FactoryNFTContractTest is Test {
    HelperConfig config;
    FactoryNFTContract factory;
    DeployFactoryNFTContract deployer;

    event CollectionCreated(
        address indexed collectionAddress,
        string indexed name,
        string indexed symbol,
        uint256 maxSupply,
        address owner,
        uint256 royaltyPercentage
    );

    string name = "MY NFT COLLECTION";
    string symbol = "MYCOL";
    string baseURI = "ipfs://";
    uint256 maxSupply = 10;
    address OWNER = makeAddr("owner");
    uint96 royaltyPercentage = 10;

    function setUp() public {
        config = new HelperConfig();

        deployer = new DeployFactoryNFTContract(address(config));
        factory = deployer.run();
    }

    function testDeployFactoryNFTContractInitialization() public {
        address configAddress = address(config);
        DeployFactoryNFTContract testDeployer = new DeployFactoryNFTContract(configAddress);
        assertEq(address(testDeployer.getHelperConfig()), configAddress);
    }

    function testConstructorSetsInitialOwnerCorrectly() public {
        address expectedOwner = makeAddr("testOwner");
        FactoryNFTContract testFactory = new FactoryNFTContract(expectedOwner);
        assertEq(testFactory.owner(), expectedOwner);
    }

    function testSuccessfulCreateCollection() public {
        vm.prank(OWNER);
        factory.createCollection(name, symbol, baseURI, maxSupply, OWNER, royaltyPercentage);
        assertEq(factory.getCollections().length, 1);
    }

    function testGetCollections() public {
        vm.prank(OWNER);
        factory.createCollection(name, symbol, baseURI, maxSupply, OWNER, royaltyPercentage);
        address expectedAddress = factory.getCollections()[0];
        address[] memory collections = factory.getCollections();
        assertEq(collections.length, 1, "Should have exactly one collection");
        assertEq(expectedAddress, factory.getCollections()[0]);
    }
}
