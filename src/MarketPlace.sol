// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

/**
 * @title MarketPlace
 * @author Shawn Rizo
 * @notice This contract will manage the listing, buying, and selling of NFTs on your marketplace.
 * It will interact with the NFT contract to transfer ownership of NFTs when a sale is made.
 * This contract will also handle the listing of NFTs for sale, the bidding process, and the settlement of sales.
 */
import {NFTContract} from "./NFTContract.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract MarkePlace is Ownable, ReentrancyGuard {
    //////////////////
    // Errors       //
    //////////////////

    //////////////////////
    // State Variables  //
    //////////////////////
    NFTContract private nftContract;

    struct Listing {
        uint256 tokenId;
        address seller;
        uint256 price;
        bool isSold;
    }

    struct Auction {
        uint256 tokenId;
        address highestBidder;
        uint256 highestBid;
        uint256 endTime;
        bool isActive;
    }

    mapping(uint256 => Listing) private s_listings;
    mapping(uint256 => Auction) private s_auctions;
    uint256 private s_totalListings;
    uint256 private s_totalAuctions;

    //////////////
    // Events   //
    //////////////

    //////////////////
    // Functions    //
    //////////////////
    constructor(address initialOwner) Ownable(initialOwner) {}

    /////////////////////////////////
    // External/Public Functions   //
    /////////////////////////////////
    function listNFT(uint256 tokenId, uint256 price) public {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(!s_listings[tokenId].isSold, "Already listed");

        s_listings[tokenId] = Listing(tokenId, msg.sender, price, false);
        s_totalListings++;
    }

    function buyNFT(uint256 tokenId) public payable nonReentrant {
        Listing storage listing = s_listings[tokenId];
        require(!listing.isSold, "Already sold");
        require(msg.value >= listing.price, "Not enough Ether");

        listing.isSold = true;
        nftContract.transferFrom(listing.seller, msg.sender, tokenId);
        payable(listing.seller).transfer(msg.value);
        s_totalListings--;
    }

    function startAuction(uint256 tokenId, uint256 endTime) public {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(!s_auctions[tokenId].isActive, "Auction already active");

        s_auctions[tokenId] = Auction(tokenId, address(0), 0, endTime, true);
        s_totalAuctions++;
    }

    function bid(uint256 tokenId) public payable nonReentrant {
        Auction storage auction = s_auctions[tokenId];
        require(auction.isActive, "Auction not active");
        require(block.timestamp < auction.endTime, "Auction ended");
        require(msg.value > auction.highestBid, "Bid too low");

        if (auction.highestBid > 0) {
            payable(auction.highestBidder).transfer(auction.highestBid);
        }

        auction.highestBidder = msg.sender;
        auction.highestBid = msg.value;
    }

    function endAuction(uint256 tokenId) public {
        Auction storage auction = s_auctions[tokenId];
        require(auction.isActive, "Auction not active");
        require(block.timestamp >= auction.endTime, "Auction not ended");

        auction.isActive = false;
        nftContract.transferFrom(nftContract.ownerOf(tokenId), auction.highestBidder, tokenId);
        payable(nftContract.ownerOf(tokenId)).transfer(auction.highestBid);
        s_totalAuctions--;
    }

    //////////////////////////////////////
    // Public/External View Functions   //
    //////////////////////////////////////
    function getTotalListings() public view returns (uint256) {
        return s_totalListings;
    }

    function getTotals_auctions() public view returns (uint256) {
        return s_totalAuctions;
    }

    function getListing(uint256 tokenId) public view returns (Listing memory) {
        return s_listings[tokenId];
    }

    function getAuction(uint256 tokenId) public view returns (Auction memory) {
        return s_auctions[tokenId];
    }
}
