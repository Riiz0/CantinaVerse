// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Test, console2, Vm } from "forge-std/Test.sol";
import { MarketPlace } from "../../src/MarketPlace.sol";
import { DeployMarketPlace } from "../../script/DeployMarketPlace.s.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { MockERC721 } from "../mocks/MockERC721.sol";

contract MarketPlaceTest is Test {
    MarketPlace marketPlace;
    DeployMarketPlace deployer;
    HelperConfig config;
    MockERC721 contractCollection1;
    MockERC721 contractCollection2;
    MockERC721 contractCollection3;
    MockERC721 contractCollection4;
    MockERC721 contractCollection5;

    address payable OWNER = payable(address(uint160(123)));
    address SELLER = makeAddr("seller");
    address SELLERTWO = makeAddr("sellerTwo");
    address SELLERTHREE = makeAddr("sellerThree");
    address BUYER = makeAddr("buy");
    uint256 constant STARTING_BALANCE = 100 ether;
    uint256 price = 1 ether;
    uint256 serviceFee = 1 ether;

    event NFTListed(address indexed seller, address indexed nftAddress, uint256 indexed tokenId, uint256 price);
    event NFTDelisted(address indexed seller, address indexed nftAddress, uint256 indexed tokenId);
    event NFTSold(address indexed buyer, address indexed nftAddress, uint256 indexed tokenId, uint256 price);
    event AuctionCreated(
        uint256 indexed auctionId,
        uint256 indexed startTime,
        uint256 indexed endTime,
        address nftAddress,
        uint256 tokenId,
        uint256 startingPrice
    );
    event BidPlaced(
        uint256 indexed auctionId, address indexed bidder, uint256 indexed bid, address nftAddress, uint256 tokenId
    );
    event AuctionEnded(
        uint256 indexed auctionId,
        address indexed winner,
        uint256 indexed winningBid,
        address nftAddress,
        uint256 tokenId
    );
    event FeeUpdated(uint256 indexed newFee);
    event GelatoAddressUpdated(address indexed newGelatoAddress);

    function setUp() public {
        config = new HelperConfig();
        deployer = new DeployMarketPlace();
        contractCollection1 = new MockERC721("Collection 1", "COL1");
        contractCollection2 = new MockERC721("Collection 2", "COL2");
        contractCollection3 = new MockERC721("Collection 3", "COL3");
        contractCollection4 = new MockERC721("Collection 4", "COL4");
        contractCollection5 = new MockERC721("Collection 5", "COL5");
        (marketPlace) = deployer.run();
        vm.deal(BUYER, STARTING_BALANCE);
        vm.deal(SELLER, STARTING_BALANCE);
        vm.deal(SELLERTWO, STARTING_BALANCE);
    }

    modifier contractCollection1SellerMints() {
        vm.prank(SELLER);
        contractCollection1.safeMint(SELLER);
        contractCollection1.safeMint(SELLER);
        contractCollection1.safeMint(SELLER);
        contractCollection1.safeMint(SELLER);
        contractCollection1.safeMint(SELLER);
        contractCollection1.safeMint(SELLER);
        contractCollection1.safeMint(SELLER);
        _;
    }

    modifier contractCollection2SellerMintsMore() {
        vm.prank(SELLER);
        contractCollection2.safeMint(SELLER);
        contractCollection2.safeMint(SELLER);
        contractCollection2.safeMint(SELLER);
        contractCollection2.safeMint(SELLER);
        contractCollection2.safeMint(SELLER);
        contractCollection2.safeMint(SELLER);
        contractCollection2.safeMint(SELLER);
        contractCollection2.safeMint(SELLER);
        contractCollection2.safeMint(SELLER);
        contractCollection2.safeMint(SELLER);
        contractCollection2.safeMint(SELLER);
        contractCollection2.safeMint(SELLER);
        _;
    }

    modifier contractCollection3SellerAndBuyerMints() {
        vm.prank(SELLER);
        contractCollection3.safeMint(SELLER);
        contractCollection3.safeMint(SELLER);
        contractCollection3.safeMint(SELLER);
        contractCollection3.safeMint(SELLER);
        contractCollection3.safeMint(SELLER);
        contractCollection3.safeMint(SELLER);
        vm.prank(BUYER);
        contractCollection3.safeMint(BUYER);
        contractCollection3.safeMint(BUYER);
        contractCollection3.safeMint(BUYER);
        contractCollection3.safeMint(BUYER);
        contractCollection3.safeMint(BUYER);
        contractCollection3.safeMint(BUYER);
        contractCollection3.safeMint(BUYER);
        contractCollection3.safeMint(BUYER);
        _;
    }

    function testConstructorSetsInitialOwnerCorrectly() public {
        address expectedOwner = makeAddr("testOwner");
        address gelatoAddress = makeAddr("testGelatoAddress");
        MarketPlace testFactory = new MarketPlace(expectedOwner, gelatoAddress, serviceFee);
        assertEq(testFactory.owner(), expectedOwner);
    }

    function testMintAndSupply()
        public
        contractCollection1SellerMints
        contractCollection2SellerMintsMore
        contractCollection3SellerAndBuyerMints
    {
        assertEq(contractCollection1.balanceOf(SELLER), 7);
        assertEq(contractCollection1.getTotalSupply(), 7);

        assertEq(contractCollection2.balanceOf(SELLER), 12);
        assertEq(contractCollection2.getTotalSupply(), 12);

        assertEq(contractCollection3.balanceOf(SELLER), 6);
        assertEq(contractCollection3.balanceOf(BUYER), 8);
        assertEq(contractCollection3.getTotalSupply(), 14);
    }

    function testTransferFrom() public {
        // Mint an NFT to the seller
        contractCollection1.safeMint(SELLER);
        assertEq(contractCollection1.ownerOf(0), SELLER, "Seller should own the token after minting");

        // Approve the buyer to transfer the NFT
        vm.prank(SELLER);
        contractCollection1.approve(BUYER, 0);

        // Transfer the NFT from seller to buyer
        vm.prank(BUYER);
        contractCollection1.transferFrom(SELLER, BUYER, 0);

        // Assert that the buyer is now the owner
        assertEq(contractCollection1.ownerOf(0), BUYER, "Buyer should own the token after transfer");
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

    function testMarketPlace__NFTAlreadyListedOrInAuction() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 3, price);
        vm.expectRevert(MarketPlace.MarketPlace__NFTAlreadyListedOrInAuction.selector);

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

        uint256 initialCounter = marketPlace.getCurrentListingIdCounter();
        marketPlace.listNFT(address(contractCollection3), 0, price);
        uint256 listingId1 = initialCounter; // Inferred ID based on the counter before listing

        initialCounter = marketPlace.getCurrentListingIdCounter();
        marketPlace.listNFT(address(contractCollection2), 0, price);
        uint256 listingId2 = initialCounter; // Next inferred ID

        initialCounter = marketPlace.getCurrentListingIdCounter();
        marketPlace.listNFT(address(contractCollection1), 0, price);
        uint256 listingId3 = initialCounter; // Next inferred ID

        vm.stopPrank();

        // Use getListingDetails to assert all details at once
        (address seller1,,, uint256 price1) = marketPlace.getListingDetails(listingId1);
        assertEq(seller1, SELLER);
        assertEq(price1, price);

        (address seller2,,, uint256 price2) = marketPlace.getListingDetails(listingId2);
        assertEq(seller2, SELLER);
        assertEq(price2, price);

        (address seller3,,, uint256 price3) = marketPlace.getListingDetails(listingId3);
        assertEq(seller3, SELLER);
        assertEq(price3, price);
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

    function testSellerSuccessfullyDelistedNFT() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        marketPlace.listNFT(address(contractCollection3), 3, price);
        vm.stopPrank();

        vm.startPrank(SELLER);
        marketPlace.delistNFT(1);
        vm.stopPrank();
        (address seller,,,) = marketPlace.getListingDetails(1);

        assertEq(seller, address(0));
    }

    function testIfMarketPlaceContractHasNotBeenApprovedByTheSeller() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        // Approve the marketplace contract to manage the NFT
        contractCollection3.approve(address(marketPlace), 2);
        vm.stopPrank();

        address approvedAddress = contractCollection3.getApproved(2);
        assertTrue(approvedAddress == address(marketPlace), "Marketplace contract should be approved");

        // Optionally, verify that the approval did not change the ownership of the NFT
        address owner = contractCollection3.ownerOf(2);
        assertTrue(owner == SELLER, "Ownership should remain unchanged after approval");
    }

    function testSellerCanDelistAndRelistNFT() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        marketPlace.delistNFT(0);
        marketPlace.listNFT(address(contractCollection3), 2, price);

        (address retrievedSeller,,,) = marketPlace.getListingDetails(0);
        vm.stopPrank();

        assertEq(retrievedSeller, SELLER);
    }

    function test_ExpectEmit_EventNFTDelisted() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 2, price);

        vm.expectEmit(true, true, true, false);
        emit NFTDelisted(address(SELLER), address(contractCollection3), 2);

        marketPlace.delistNFT(0);
        vm.stopPrank();
    }

    function test_DelistNFT_MarketPlace__NFTNotListed() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        vm.expectRevert(MarketPlace.MarketPlace__NFTNotListed.selector);
        marketPlace.delistNFT(0);
        vm.stopPrank();
    }

    function testIfBuyerValueEqualsAmount() public contractCollection3SellerAndBuyerMints {
        uint256 testPrice = 5 ether;
        vm.startPrank(SELLER);
        marketPlace.getNFTStatus(address(contractCollection3), 2);
        contractCollection3.approve(address(marketPlace), 2);
        marketPlace.listNFT(address(contractCollection3), 2, testPrice);
        marketPlace.getNFTStatus(address(contractCollection3), 2);

        (address seller, address nftAddress, uint256 tokenId, uint256 listedPrice) = marketPlace.getListingDetails(0);
        assertEq(listedPrice, testPrice);
        assertEq(nftAddress, address(contractCollection3));
        assertEq(tokenId, 2);
        assertEq(seller, SELLER);
        vm.stopPrank();

        // Calculate expected total cost
        uint256 currentFee = marketPlace.getFee();
        uint256 expectedTotalCost = testPrice + currentFee;

        vm.startPrank(BUYER);
        marketPlace.buyNFT{ value: expectedTotalCost }(0);
        marketPlace.getNFTStatus(address(contractCollection3), 2);
        vm.stopPrank();

        assertEq(contractCollection3.ownerOf(2), BUYER);
    }

    function testIfBuyerValueIsNotEqualToAmount() public contractCollection3SellerAndBuyerMints {
        uint256 amount = 2 ether;
        vm.startPrank(SELLER);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        vm.stopPrank();

        vm.startPrank(BUYER);
        vm.expectRevert(MarketPlace.MarketPlace__InsufficientFundsOrExcessFundsToPurchase.selector);
        marketPlace.buyNFT{ value: amount }(0);
        vm.stopPrank();
    }

    function testBuyNFTFunctionIfSellerIsNFTOwnerOfNFTListed() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        marketPlace.listNFT(address(contractCollection3), 2, price);
        vm.stopPrank();

        vm.startPrank(BUYER);
        assertEq(contractCollection3.ownerOf(2), SELLER);
        vm.stopPrank();
    }

    function test_BuyNFT_MarketPlace__NFTNotListed() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        vm.expectRevert(MarketPlace.MarketPlace__NFTNotListed.selector);
        marketPlace.buyNFT{ value: price }(0);
        vm.stopPrank();
    }

    function test_ExpectEmit_EventNFTSold() public contractCollection3SellerAndBuyerMints {
        uint256 testPrice = 5 ether;
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        marketPlace.listNFT(address(contractCollection3), 2, testPrice);
        vm.stopPrank();

        uint256 totalPrice = testPrice + marketPlace.getFee();

        vm.startPrank(BUYER);
        vm.expectEmit(true, true, true, true);
        emit NFTSold(BUYER, address(contractCollection3), 2, testPrice);
        marketPlace.buyNFT{ value: totalPrice }(0);
        vm.stopPrank();
    }

    function test_CreateAuction_MarketPlace__NFTAlreadyListedOrInAuction()
        public
        contractCollection3SellerAndBuyerMints
    {
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        marketPlace.createAuction(address(contractCollection3), 2, price, 1 days);

        vm.expectRevert(MarketPlace.MarketPlace__NFTAlreadyListedOrInAuction.selector);
        marketPlace.createAuction(address(contractCollection3), 2, price, 5 days);
        vm.stopPrank();
    }

    function test_MarketPlace__AuctionNotTheOwner() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(BUYER);
        vm.expectRevert(MarketPlace.MarketPlace__AuctionNotTheOwner.selector);
        marketPlace.createAuction(address(contractCollection3), 2, price, 5 days);
        vm.stopPrank();
    }

    function test_MarketPlace__PriceCannotBeZero() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        vm.expectRevert(MarketPlace.MarketPlace__PriceCannotBeZero.selector);
        marketPlace.createAuction(address(contractCollection3), 2, 0, 1 days);
        vm.stopPrank();
    }

    function test_ExpectEmit_CreateAuctionSuccessfulWithEmit() public contractCollection3SellerAndBuyerMints {
        uint256 testStartTime = block.timestamp;
        uint256 durationOfDays = 1 days;
        uint256 durationInMinutes = durationOfDays * 60;
        uint256 endTime = block.timestamp + durationInMinutes;

        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        vm.expectEmit(true, true, true, true);
        emit AuctionCreated(0, testStartTime, endTime, address(contractCollection3), 2, price);
        marketPlace.createAuction(address(contractCollection3), 2, price, 1 days);
        vm.stopPrank();

        assertEq(contractCollection3.ownerOf(2), address(marketPlace));
    }

    function test_BidOnAuction_MarketPlace__NFTAlreadyListedOrInAuction()
        public
        contractCollection3SellerAndBuyerMints
    {
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 3);
        marketPlace.listNFT(address(contractCollection3), 3, price);

        vm.expectRevert(MarketPlace.MarketPlace__NFTInAuctionStatus.selector);
        marketPlace.bidOnAuction{ value: price }(0);
        vm.stopPrank();
    }

    function test_MarketPlace__NFTAuctionHasEnded() public contractCollection3SellerAndBuyerMints {
        uint256 testStartTime = block.timestamp;
        uint256 durationOfDays = 1 days;
        uint256 durationInMinutes = durationOfDays * 60;
        uint256 endTime = block.timestamp + durationInMinutes;

        uint256 daysAfterEnd = 2 days;
        uint256 durationInMinutesAfterEnd = daysAfterEnd * 60;

        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        vm.expectEmit(true, true, true, true);
        emit AuctionCreated(0, testStartTime, endTime, address(contractCollection3), 2, price);
        marketPlace.createAuction(address(contractCollection3), 2, price, 1 days);
        vm.stopPrank();
        vm.warp(durationInMinutesAfterEnd);
        vm.startPrank(BUYER);
        vm.expectRevert(MarketPlace.MarketPlace__NFTAuctionHasEnded.selector);
        marketPlace.bidOnAuction{ value: price }(0);
        vm.stopPrank();
    }

    function test_MarketPlace__BidIsLessThanHighestBid() public contractCollection3SellerAndBuyerMints {
        uint256 testStartTime = block.timestamp;
        uint256 durationOfDays = 1 days;
        uint256 durationInMinutes = durationOfDays * 60;
        uint256 endTime = block.timestamp + durationInMinutes;

        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        vm.expectEmit(true, true, true, true);
        emit AuctionCreated(0, testStartTime, endTime, address(contractCollection3), 2, price);
        marketPlace.createAuction(address(contractCollection3), 2, price, 1 days);
        vm.stopPrank();

        vm.startPrank(BUYER);
        marketPlace.bidOnAuction{ value: price }(0);
        vm.stopPrank();

        vm.startPrank(SELLERTWO);
        vm.expectRevert(MarketPlace.MarketPlace__BidIsLessThanHighestBid.selector);
        marketPlace.bidOnAuction{ value: 0.5 ether }(0);
        vm.stopPrank();
    }

    function testBidOnAuctionSuccessful() public contractCollection3SellerAndBuyerMints {
        uint256 highBid = 5 ether;
        uint256 HighestBid = 6 ether;
        uint256 testStartTime = block.timestamp;
        uint256 durationOfDays = 1 days;
        uint256 durationInMinutes = durationOfDays * 60;
        uint256 endTime = block.timestamp + durationInMinutes;

        uint256 daysAfterEnd = 2 days;
        uint256 durationInMinutesAfterEnd = daysAfterEnd * 60;

        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 2);
        vm.expectEmit(true, true, true, true);
        emit AuctionCreated(0, testStartTime, endTime, address(contractCollection3), 2, price);
        marketPlace.createAuction(address(contractCollection3), 2, price, 1 days);
        vm.stopPrank();

        vm.startPrank(BUYER);
        vm.expectEmit(true, true, true, true);
        emit BidPlaced(0, BUYER, highBid, address(contractCollection3), 2);
        marketPlace.bidOnAuction{ value: highBid }(0);
        vm.stopPrank();
        vm.startPrank(SELLERTWO);
        vm.expectEmit(true, true, true, true);
        emit BidPlaced(0, SELLERTWO, HighestBid, address(contractCollection3), 2);
        marketPlace.bidOnAuction{ value: HighestBid }(0);
        vm.stopPrank();
        vm.warp(durationInMinutesAfterEnd);
    }

    function testWithdrawSuccessful() public contractCollection3SellerAndBuyerMints {
        uint256 testPrice = 5 ether;

        vm.startPrank(address(1));
        marketPlace.setFee(1 ether);
        vm.stopPrank();

        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 3);
        contractCollection3.approve(address(marketPlace), 4);
        contractCollection3.approve(address(marketPlace), 5);
        marketPlace.listNFT(address(contractCollection3), 3, testPrice);
        marketPlace.listNFT(address(contractCollection3), 4, testPrice);
        marketPlace.listNFT(address(contractCollection3), 5, testPrice);
        vm.stopPrank();
        vm.startPrank(BUYER);
        uint256 totalCost = testPrice + marketPlace.getFee();
        marketPlace.buyNFT{ value: totalCost }(0);
        marketPlace.buyNFT{ value: totalCost }(1);
        marketPlace.buyNFT{ value: totalCost }(2);
        vm.stopPrank();

        uint256 balanceOfMarketPlace = address(marketPlace).balance;

        vm.startPrank(address(1));
        marketPlace.withdraw(OWNER, balanceOfMarketPlace);
        vm.stopPrank();

        assertEq(address(OWNER).balance, balanceOfMarketPlace);
    }

    function test_MarketPlace__CantBeZeroAddress() public contractCollection3SellerAndBuyerMints {
        uint256 testPrice = 5 ether;

        vm.startPrank(address(1));
        marketPlace.setFee(1 ether);
        vm.stopPrank();

        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 3);
        contractCollection3.approve(address(marketPlace), 4);
        contractCollection3.approve(address(marketPlace), 5);
        marketPlace.listNFT(address(contractCollection3), 3, testPrice);
        marketPlace.listNFT(address(contractCollection3), 4, testPrice);
        marketPlace.listNFT(address(contractCollection3), 5, testPrice);
        vm.stopPrank();
        vm.startPrank(BUYER);
        uint256 totalCost = testPrice + marketPlace.getFee();
        marketPlace.buyNFT{ value: totalCost }(0);
        marketPlace.buyNFT{ value: totalCost }(1);
        marketPlace.buyNFT{ value: totalCost }(2);
        vm.stopPrank();

        uint256 balanceOfMarketPlace = address(marketPlace).balance;

        vm.startPrank(address(1));
        vm.expectRevert(MarketPlace.MarketPlace__CantBeZeroAddress.selector);
        marketPlace.withdraw(payable(address(0)), balanceOfMarketPlace);
        vm.stopPrank();
    }

    function test_MarketPlace__CantBeZeroAmount() public contractCollection3SellerAndBuyerMints {
        uint256 testPrice = 5 ether;

        vm.startPrank(address(1));
        marketPlace.setFee(1 ether);
        vm.stopPrank();

        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 3);
        contractCollection3.approve(address(marketPlace), 4);
        contractCollection3.approve(address(marketPlace), 5);
        marketPlace.listNFT(address(contractCollection3), 3, testPrice);
        marketPlace.listNFT(address(contractCollection3), 4, testPrice);
        marketPlace.listNFT(address(contractCollection3), 5, testPrice);
        vm.stopPrank();
        vm.startPrank(BUYER);
        uint256 totalCost = testPrice + marketPlace.getFee();
        marketPlace.buyNFT{ value: totalCost }(0);
        marketPlace.buyNFT{ value: totalCost }(1);
        marketPlace.buyNFT{ value: totalCost }(2);
        vm.stopPrank();

        vm.startPrank(address(1));
        vm.expectRevert(MarketPlace.MarketPlace__CantBeZeroAmount.selector);
        marketPlace.withdraw(OWNER, 0);
        vm.stopPrank();
    }

    function testGetListingDetails() public contractCollection3SellerAndBuyerMints {
        vm.startPrank(SELLER);
        contractCollection3.approve(address(marketPlace), 3);
        marketPlace.listNFT(address(contractCollection3), 3, price);
        vm.stopPrank();

        // Retrieve listing details using the expected listing ID
        (address seller, address nftAddress, uint256 tokenId, uint256 listedPrice) = marketPlace.getListingDetails(0);

        // Assertions to verify the listing details
        assertEq(seller, SELLER, "Seller address does not match");
        assertEq(nftAddress, address(contractCollection3), "NFT address does not match");
        assertEq(tokenId, 3, "Token ID does not match");
        assertEq(listedPrice, price, "Price does not match");
    }

    function test_MarketPlace__InvalidListingId() public {
        vm.expectRevert(MarketPlace.MarketPlace__InvalidListingId.selector);
        marketPlace.getListingDetails(1);
    }
}
