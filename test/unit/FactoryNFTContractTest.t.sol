// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Test, console2, Vm } from "forge-std/Test.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { FactoryNFTContract } from "../../src/marketplace/FactoryNFTContract.sol";
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
        uint256 royaltyPercentage,
        uint256 mintPrice
    );

    string name = "MY NFT COLLECTION";
    string symbol = "MYCOL";
    string baseURI = "https://silver-selective-kite-794.mypinata.cloud/ipfs/";
    uint256 maxSupply = 10;
    address OWNER = makeAddr("owner");
    address payable PERSONAL = payable(address(uint160(123)));
    uint96 royaltyPercentage = 10;
    uint256 mintPrice = 0;

    function setUp() public {
        config = new HelperConfig();
        deployer = new DeployFactoryNFTContract();
        factory = deployer.run();

        vm.deal(OWNER, 10 ether);
    }

    function testDeployOnAnvil() public {
        vm.chainId(31_337);
        assertEq(factory.owner(), config.getAnvilConfig().initialOwner);
        assertEq(factory.getFee(), config.getAnvilConfig().serviceFee);
    }

    function testDeployOnSepolia() public {
        vm.chainId(11_155_111);
        assertEq(address(0xfe63Ba8189215E5C975e73643b96066B6aD41A45), config.getSepoliaConfig().initialOwner);
        assertEq(factory.getFee(), config.getSepoliaConfig().serviceFee);
    }

    function testDeployOnBaseMainnet() public {
        vm.chainId(8453);
        assertEq(address(0xfe63Ba8189215E5C975e73643b96066B6aD41A45), config.getBaseMainnetConfig().initialOwner);
        assertEq(factory.getFee(), config.getBaseMainnetConfig().serviceFee);
    }

    function testDeployOnOptimismMainnet() public {
        vm.chainId(10);
        assertEq(address(0xfe63Ba8189215E5C975e73643b96066B6aD41A45), config.getOpMainnetConfig().initialOwner);
        assertEq(factory.getFee(), config.getOpMainnetConfig().serviceFee);
    }

    function testDeployOnModeMainnet() public {
        vm.chainId(34_443);
        assertEq(address(0xfe63Ba8189215E5C975e73643b96066B6aD41A45), config.getModeMainnetConfig().initialOwner);
        assertEq(factory.getFee(), config.getModeMainnetConfig().serviceFee);
    }

    function testRevertOnUnsupportedNetwork() public {
        vm.chainId(1); // Ethereum mainnet, which is not supported in your script
        vm.expectRevert("Unsupported network");
        deployer.run();
    }

    function testConstructorSetsInitialOwnerCorrectly() public {
        console2.log(factory.owner());
        address expectedOwner = makeAddr("testOwner");
        FactoryNFTContract testFactory = new FactoryNFTContract(expectedOwner, 0);
        assertEq(testFactory.owner(), expectedOwner);
    }

    function testSuccessfulCreateCollection() public {
        vm.prank(OWNER);
        factory.createCollection(name, symbol, maxSupply, OWNER, royaltyPercentage, mintPrice);
        assertEq(factory.getCollections().length, 1);
    }

    function test_FactoryNFTContract__InsufficientFunds() public {
        uint256 testPrice = 1 ether;

        vm.startPrank(address(1));
        factory.setFee(1 ether);
        vm.stopPrank();

        vm.startPrank(address(1));
        vm.expectRevert(FactoryNFTContract.FactoryNFTContract__InsufficientFunds.selector);
        factory.createCollection{ value: 0 }(name, symbol, maxSupply, OWNER, royaltyPercentage, testPrice);
        vm.stopPrank();
    }

    function test_FactoryNFTContract_WithdrawSuccessful() public {
        uint256 testPrice = 1 ether;

        vm.startPrank(address(1));
        factory.setFee(1 ether);
        vm.stopPrank();

        vm.startPrank(OWNER);
        factory.createCollection{ value: testPrice }(name, symbol, maxSupply, OWNER, royaltyPercentage, mintPrice);
        vm.stopPrank();

        assertEq(factory.getCollections().length, 1);

        vm.startPrank(address(1));
        factory.withdraw(PERSONAL, testPrice);
        vm.stopPrank();

        assertEq(address(PERSONAL).balance, testPrice);
    }

    function test_FactoryNFTContract__CantBeZeroAddress() public {
        uint256 testPrice = 1 ether;

        vm.startPrank(address(1));
        factory.setFee(1 ether);
        vm.stopPrank();

        vm.startPrank(OWNER);
        factory.createCollection{ value: testPrice }(name, symbol, maxSupply, OWNER, royaltyPercentage, mintPrice);
        vm.stopPrank();

        vm.startPrank(address(1));
        vm.expectRevert(FactoryNFTContract.FactoryNFTContract__CantBeZeroAddress.selector);
        factory.withdraw(payable(address(0)), testPrice);
        vm.stopPrank();
    }

    function test_FactoryNFTContract__CantBeZeroAmount() public {
        uint256 testPrice = 1 ether;

        vm.startPrank(address(1));
        factory.setFee(1 ether);
        vm.stopPrank();

        vm.startPrank(OWNER);
        factory.createCollection{ value: testPrice }(name, symbol, maxSupply, OWNER, royaltyPercentage, mintPrice);
        vm.stopPrank();

        vm.startPrank(address(1));
        vm.expectRevert(FactoryNFTContract.FactoryNFTContract__CantBeZeroAmount.selector);
        factory.withdraw(PERSONAL, 0);
        vm.stopPrank();
    }

    function testGetCollections() public {
        vm.prank(OWNER);
        factory.createCollection(name, symbol, maxSupply, OWNER, royaltyPercentage, mintPrice);
        address expectedAddress = factory.getCollections()[0];
        address[] memory collections = factory.getCollections();
        assertEq(collections.length, 1, "Should have exactly one collection");
        assertEq(expectedAddress, factory.getCollections()[0]);
    }

    function testSetFee() public {
        vm.startPrank(address(1));
        uint256 expectedFee = 1 ether;
        factory.setFee(expectedFee);
        vm.stopPrank();

        assertEq(factory.getFee(), expectedFee);
    }
}
