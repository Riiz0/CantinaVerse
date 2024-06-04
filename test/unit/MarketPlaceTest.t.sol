// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Test, console2 } from "forge-std/Test.sol";
import { MarketPlace } from "../../src/MarketPlace.sol";
import { DeployerMarketPlace } from "../../scripts/DeployMarketPlace.s.sol";
import { HelperConfig } from "../../scripts/HelperConfig.s.sol";
import { MockERC721 } from "../mocks/MockERC721.sol";

contract MarketPlaceTest is Test {
    MarketPlace marketPlace;
    DeployerMarketPlace deployer;
    HelperConfig config;
    MockERC721 contractCollection1;
    MockERC721 contractCollection2;
    MockERC721 contractCollection3;

    address SELLER = makeAddr("seller");
    address BUYER = makeAddr("buy");
    uint256 constant STARTING_BALANCE = 100 ether;
    uint256 price = 1 ether;

    function setUp() public {
        config = new HelperConfig();
        deployer = new DeployerMarketPlace(address(config));
        contractCollection1 = new MockERC721("Collection 1", "COL1");
        contractCollection2 = new MockERC721("Collection 2", "COL2");
        contractCollection3 = new MockERC721("Collection 3", "COL3");
        marketPlace = deployer.run();
        vm.deal(BUYER, STARTING_BALANCE);
        vm.deal(SELLER, STARTING_BALANCE);
    }

    modifier contractCollection1Mints() {
        vm.prank(SELLER);
        contractCollection1.mint(SELLER, 1);
        contractCollection1.mint(SELLER, 2);
        contractCollection1.mint(SELLER, 3);
        contractCollection1.mint(SELLER, 4);
        contractCollection1.mint(SELLER, 5);
        contractCollection1.mint(SELLER, 6);
        _;
    }

    modifier contractCollection2Mints() {
        vm.prank(SELLER);
        contractCollection2.mint(SELLER, 1);
        contractCollection2.mint(SELLER, 2);
        contractCollection2.mint(SELLER, 3);
        contractCollection2.mint(SELLER, 4);
        contractCollection2.mint(SELLER, 5);
        contractCollection2.mint(SELLER, 6);
        contractCollection2.mint(SELLER, 7);
        contractCollection2.mint(SELLER, 8);
        contractCollection2.mint(SELLER, 9);
        contractCollection2.mint(SELLER, 10);
        contractCollection2.mint(SELLER, 11);
        _;
    }

    modifier contractCollection3Mints() {
        vm.prank(SELLER);
        contractCollection3.mint(SELLER, 1);
        contractCollection3.mint(SELLER, 2);
        contractCollection3.mint(SELLER, 3);
        contractCollection3.mint(SELLER, 4);
        contractCollection3.mint(SELLER, 5);
        vm.prank(BUYER);
        contractCollection3.mint(BUYER, 6);
        contractCollection3.mint(BUYER, 7);
        contractCollection3.mint(BUYER, 8);
        contractCollection3.mint(BUYER, 9);
        contractCollection3.mint(BUYER, 10);
        contractCollection3.mint(BUYER, 11);
        contractCollection3.mint(BUYER, 12);
        contractCollection3.mint(BUYER, 13);
        _;
    }

    function testMintAndSupply() public contractCollection1Mints contractCollection2Mints contractCollection3Mints {
        assertEq(contractCollection1.balanceOf(SELLER), 6);
        assertEq(contractCollection1.totalSupply(), 6);

        assertEq(contractCollection2.balanceOf(SELLER), 11);
        assertEq(contractCollection2.totalSupply(), 11);

        assertEq(contractCollection3.balanceOf(SELLER), 5);
        assertEq(contractCollection3.balanceOf(BUYER), 8);
        assertEq(contractCollection3.totalSupply(), 13);
    }

    function testMarketPlaceListNFTIsTheOwner() public contractCollection3Mints {
        vm.prank(SELLER);
        marketPlace.listNFT(1, address(contractCollection3), price);
    }

    function testRevertMarketPlace__ListNFTNotTheOwner() public contractCollection1Mints {
        vm.prank(BUYER);
        marketPlace.listNFT(1, address(contractCollection1), price);
        vm.expectRevert(MarketPlace.MarketPlace__ListNFTNotTheOwner.selector);
    }

    function testMarketPlaceIsntListed() public contractCollection3Mints {
        vm.prank(SELLER);
        //marketPlace.existingListing = s_listings[2];
        marketPlace.listNFT(2, address(contractCollection3), price);
    }

    function testRevertMarketPlace__AlreadyListed() public contractCollection3Mints {
        vm.prank(SELLER);
        marketPlace.listNFT(3, address(contractCollection3), price);
        vm.expectRevert(MarketPlace.MarketPlace__AlreadyListed.selector);
    }

    function testMarketPlaceInsufficientFundsToPurchaseError() public { }

    function testMarketPlaceExcessFundsToPurchaseError() public { }

    function testMarketPlaceAlreadyListedError() public { }

    function testMarketPlaceNotSellerError() public { }

    function MarketPlaceCannotUpdateSoldListingError() public { }
}
