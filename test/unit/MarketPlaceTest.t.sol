// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Test, console2, Vm } from "forge-std/Test.sol";
import { MarketPlace } from "../../src/MarketPlace.sol";
import { DeployerMarketPlace } from "../../script/DeployMarketPlace.s.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { MockERC721 } from "../mocks/MockERC721.sol";

contract MarketPlaceTest is Test {
    MarketPlace marketPlace;
    DeployerMarketPlace deployer;
    HelperConfig config;
    MockERC721 contractCollection1;
    MockERC721 contractCollection2;
    MockERC721 contractCollection3;
    MockERC721 contractCollection4;
    MockERC721 contractCollection5;

    address SELLER = makeAddr("seller");
    address BUYER = makeAddr("buy");
    uint256 constant STARTING_BALANCE = 100 ether;
    uint256 price = 1 ether;

    event NFTListed(address indexed seller, address indexed nftContract, uint256 indexed tokenId, uint256 price);
    event NFTDelisted(address indexed seller, address indexed nftContract, uint256 indexed tokenId);
    event NFTSold(address indexed buyer, address indexed nftContract, uint256 indexed tokenId, uint256 price);
    event NewNFTListingPrice(
        address indexed seller, address indexed nftContract, uint256 indexed tokenId, uint256 newPrice
    );
    event ProceedsWithdrawn(address indexed seller, uint256 indexed amount);

    function setUp() public {
        config = new HelperConfig();
        deployer = new DeployerMarketPlace(address(config));
        contractCollection1 = new MockERC721("Collection 1", "COL1");
        contractCollection2 = new MockERC721("Collection 2", "COL2");
        contractCollection3 = new MockERC721("Collection 3", "COL3");
        contractCollection4 = new MockERC721("Collection 4", "COL4");
        contractCollection5 = new MockERC721("Collection 5", "COL5");
        marketPlace = deployer.run();
        vm.deal(BUYER, STARTING_BALANCE);
        vm.deal(SELLER, STARTING_BALANCE);
    }

    modifier contractCollection1SellerMints() {
        vm.prank(SELLER);
        contractCollection1.mint(SELLER, 0);
        contractCollection1.mint(SELLER, 1);
        contractCollection1.mint(SELLER, 2);
        contractCollection1.mint(SELLER, 3);
        contractCollection1.mint(SELLER, 4);
        contractCollection1.mint(SELLER, 5);
        contractCollection1.mint(SELLER, 6);
        _;
    }

    modifier contractCollection2SellerMintsMore() {
        vm.prank(SELLER);
        contractCollection2.mint(SELLER, 0);
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

    modifier contractCollection3SellerAndBuyerMints() {
        vm.prank(SELLER);
        contractCollection3.mint(SELLER, 0);
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

    function testMintAndSupply()
        public
        contractCollection1SellerMints
        contractCollection2SellerMintsMore
        contractCollection3SellerAndBuyerMints
    {
        assertEq(contractCollection1.balanceOf(SELLER), 7);
        assertEq(contractCollection1.totalSupply(), 7);

        assertEq(contractCollection2.balanceOf(SELLER), 12);
        assertEq(contractCollection2.totalSupply(), 12);

        assertEq(contractCollection3.balanceOf(SELLER), 6);
        assertEq(contractCollection3.balanceOf(BUYER), 8);
        assertEq(contractCollection3.totalSupply(), 14);
    }

    function testOwnerIsTheSellerListingNFT() public contractCollection3SellerAndBuyerMints {
        vm.prank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 1, price);
        address owner = contractCollection3.ownerOf(1);
        assertEq(owner, address(SELLER));
    }

    function testSellerIsNotTheOwnerListingNFT() public contractCollection1SellerMints {
        vm.startPrank(BUYER);

        vm.expectRevert(MarketPlace.MarketPlace__ListNFTNotTheOwner.selector);
        marketPlace.listNFT(address(contractCollection1), 1, price);
        vm.stopPrank();
    }

    function testMarketPlace__AlreadyListed() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 3, price);
        vm.expectRevert(MarketPlace.MarketPlace__AlreadyListed.selector);

        marketPlace.listNFT(address(contractCollection3), 3, price); // Second listing should revert    }
        vm.stopPrank();
    }

    function testOwnerIsListingNFTSuccessfully()
        public
        contractCollection1SellerMints
        contractCollection2SellerMintsMore
        contractCollection3SellerAndBuyerMints
    {
        vm.startPrank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 0, price);
        marketPlace.listNFT(address(contractCollection2), 0, price);
        marketPlace.listNFT(address(contractCollection1), 0, price);
        vm.stopPrank();

        // Assert that the listings exist with the correct price and seller address
        MarketPlace.Listing memory listing1 = marketPlace.getListing(address(contractCollection3), 0);
        assertEq(listing1.price, price);
        assertEq(listing1.seller, SELLER);

        MarketPlace.Listing memory listing2 = marketPlace.getListing(address(contractCollection2), 0);
        assertEq(listing2.price, price);
        assertEq(listing2.seller, SELLER);

        MarketPlace.Listing memory listing3 = marketPlace.getListing(address(contractCollection1), 0);
        assertEq(listing3.price, price);
        assertEq(listing3.seller, SELLER);
    }

    function testIfPriceOfListedNFTIsZero() public contractCollection3SellerAndBuyerMints {
        uint256 zeroPrice = 0 ether;
        vm.startPrank(SELLER);
        vm.expectRevert(MarketPlace.MarketPlace__PriceCannotBeZero.selector);
        marketPlace.listNFT(address(contractCollection3), 3, zeroPrice);
        vm.stopPrank();
    }

    function test_ExpectEmit_EventNFTListed() public contractCollection3SellerAndBuyerMints {
        vm.prank(SELLER);
        vm.expectEmit(true, true, true, false);
        emit NFTListed(address(SELLER), address(contractCollection3), 3, price);
        marketPlace.listNFT(address(contractCollection3), 3, price);
    }

    function testCallerIsTheSellerForDelistingNFT() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        marketPlace.listNFT(address(contractCollection3), 3, price);

        marketPlace.delistNFT(address(contractCollection3), 2);

        // Fetch the listing for the delisted NFT
        MarketPlace.Listing memory listing = marketPlace.getListing(address(contractCollection3), 2);

        // Assert that the listing's seller is the zero address, indicating it has been removed
        assertEq(listing.seller, address(0));
        vm.stopPrank();
    }

    function testIfCallerIsNotTheSellerForDelistingNFT() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        vm.stopPrank();

        vm.startPrank(BUYER);
        vm.expectRevert(
            abi.encodeWithSelector(MarketPlace.MarketPlace__NotTheSeller.selector, address(contractCollection3), 2)
        );
        marketPlace.delistNFT(address(contractCollection3), 2);
        vm.stopPrank();
    }

    function testSellerCanDelistAndRelistNFT() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        marketPlace.delistNFT(address(contractCollection3), 2);

        MarketPlace.Listing memory listing = marketPlace.getListing(address(contractCollection3), 2);
        assertEq(listing.seller, address(0));

        marketPlace.listNFT(address(contractCollection3), 2, price);

        MarketPlace.Listing memory listing1 = marketPlace.getListing(address(contractCollection3), 2);

        assertEq(listing1.seller, address(SELLER));
        vm.stopPrank();
    }

    function test_ExpectEmit_EventNFTDelisted() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 2, price);

        vm.expectEmit(true, true, true, false);
        emit NFTDelisted(address(SELLER), address(contractCollection3), 2);

        marketPlace.delistNFT(address(contractCollection3), 2);
        vm.stopPrank();
    }

    function testIfBuyerValueEqualsAmount() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        vm.stopPrank();

        vm.prank(BUYER);
        marketPlace.buyNFT{ value: price }(address(contractCollection3), 2);

        assertEq(contractCollection3.ownerOf(2), BUYER);
    }

    function testIfBuyerValueIsNotEqualToAmount() public contractCollection3SellerAndBuyerMints {
        uint256 amount = 2 ether;
        vm.startPrank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        vm.stopPrank();

        vm.startPrank(BUYER);
        vm.expectRevert(
            abi.encodeWithSelector(
                MarketPlace.MarketPlace__InsufficientFundsOrExcessFundsToPurchase.selector,
                address(contractCollection3),
                2,
                price
            )
        );
        marketPlace.buyNFT{ value: amount }(address(contractCollection3), 2);
        vm.stopPrank();
    }

    function testViewProceedsOfSuccessfulListingAndBuyingOfNFT() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        vm.stopPrank();

        vm.startPrank(BUYER);
        marketPlace.buyNFT{ value: price }(address(contractCollection3), 2);
        vm.stopPrank();

        assertEq(contractCollection3.ownerOf(2), BUYER);

        vm.startPrank(SELLER);
        marketPlace.getSellerProceeds(SELLER);
        vm.stopPrank();

        assertEq(marketPlace.getSellerProceeds(SELLER), price);
    }

    function test_ExpectEmit_EventNFTSold() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        vm.stopPrank();

        vm.startPrank(BUYER);
        vm.expectEmit(true, true, true, false);
        emit NFTSold(BUYER, address(contractCollection3), 2, price);
        marketPlace.buyNFT{ value: price }(address(contractCollection3), 2);
        vm.stopPrank();
    }

    function testSuccessfulWithdrawProceeds() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        vm.stopPrank();

        assertEq(marketPlace.getSellerProceeds(SELLER), 0);
        uint256 beforeBalanceOfSeller = address(SELLER).balance;

        vm.startPrank(BUYER);
        marketPlace.buyNFT{ value: price }(address(contractCollection3), 2);
        vm.stopPrank();

        vm.startPrank(SELLER);
        uint256 payment = marketPlace.getSellerProceeds(SELLER);
        assertEq(marketPlace.getSellerProceeds(SELLER), payment);
        marketPlace.withdrawProceeds();
        assertEq(marketPlace.getSellerProceeds(SELLER), 0);
        assertEq(address(SELLER).balance, payment + beforeBalanceOfSeller);
        vm.stopPrank();
    }

    function testIfAmountIsLessThanOrEqualToProceeds() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        marketPlace.listNFT(address(contractCollection3), 2, price);

        assertEq(marketPlace.getSellerProceeds(SELLER), 0);

        vm.expectRevert(MarketPlace.MarketPlace__NoProceeds.selector);
        marketPlace.withdrawProceeds();
        vm.stopPrank();
    }

    function testIfBoolCallFails() public {
        // Deploy the RejectingReceiver contract
        RejectingReceiver rejectingReceiver = new RejectingReceiver();
        address rejectAddress = address(rejectingReceiver);

        // Setup the market with the rejecting contract as the seller
        vm.startPrank(rejectAddress);
        contractCollection5.mint(rejectAddress, 0);
        contractCollection5.mint(rejectAddress, 1);
        vm.stopPrank();

        vm.startPrank(rejectAddress);
        contractCollection5.approve(address(marketPlace), 1);
        marketPlace.listNFT(address(contractCollection5), 1, price);
        vm.stopPrank();

        // Buy the NFT as a different user to ensure there are proceeds to withdraw
        vm.startPrank(BUYER);
        marketPlace.buyNFT{ value: price }(address(contractCollection5), 1);
        vm.stopPrank();

        // Attempt to withdraw proceeds as the rejecting contract and expect failure
        vm.startPrank(rejectAddress);
        vm.expectRevert(MarketPlace.MarketPlace__TransferFailed.selector);
        marketPlace.withdrawProceeds();
        vm.stopPrank();
    }

    function test_ExpectEmit_EventProceedsWithdrawn() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        vm.stopPrank();

        vm.startPrank(BUYER);
        marketPlace.buyNFT{ value: price }(address(contractCollection3), 2);
        vm.stopPrank();

        vm.startPrank(SELLER);
        vm.expectEmit(true, true, false, false);
        emit ProceedsWithdrawn(SELLER, price);
        marketPlace.withdrawProceeds();
        vm.stopPrank();
    }

    function testGetListing() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 3);
        marketPlace.listNFT(address(contractCollection3), 3, price);
        marketPlace.getListing(address(contractCollection3), 3);
        vm.stopPrank();

        assertEq(marketPlace.getListing(address(contractCollection3), 3).seller, SELLER);
    }

    function testGetSellerProceeds() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        marketPlace.getSellerProceeds(SELLER);
        assertEq(marketPlace.getSellerProceeds(BUYER), 0);

        vm.startPrank(BUYER);
        marketPlace.buyNFT{ value: price }(address(contractCollection3), 2);
        vm.stopPrank();

        vm.startPrank(SELLER);
        marketPlace.getSellerProceeds(BUYER);
        vm.stopPrank();

        assertEq(marketPlace.getSellerProceeds(SELLER), 1 ether);
        assertEq(marketPlace.getSellerProceeds(BUYER), 0);
    }

    ////////////////////
    // Fuzz Testing  //
    ///////////////////
    function testFuzz_ListNFT(uint256 tokenId, uint96 amount) public {
        if (amount == 0) return;

        vm.startPrank(SELLER);
        contractCollection4.mint(SELLER, tokenId);

        marketPlace.listNFT(address(contractCollection4), tokenId, amount);

        // Assertions: Verify the NFT is listed correctly.
        MarketPlace.Listing memory listing = marketPlace.getListing(address(contractCollection4), tokenId);
        assertEq(listing.price, amount);
        assertEq(listing.seller, SELLER);

        vm.stopPrank();
    }
}

// Contract that rejects receiving Ether for testIfBoolSuccessFails()
contract RejectingReceiver {
    receive() external payable {
        revert("RejectingReceiver: reject Ether");
    }
}
