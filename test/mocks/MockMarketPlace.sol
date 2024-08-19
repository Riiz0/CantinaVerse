// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { IMarketPlace } from "../../src/marketplace/interfaces/IMarketPlace.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { IERC721Receiver } from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract MockMarketPlace is IMarketPlace, IERC721Receiver {
    error MarketPlace__TransferFailed();

    struct Auction {
        address seller;
        address highestBidder;
        address nftAddress;
        uint256 tokenId;
        uint256 startingPrice;
        uint256 highestBid;
        uint256 startTime;
        uint256 endTime;
    }

    mapping(uint256 => Auction) private s_auctions;
    uint256 private s_auctionIdCounter;
    address public dedicatedMsgSender;
    uint256 private constant DURATION = 14 days;

    event AuctionEnded(
        uint256 indexed auctionId,
        address indexed winner,
        uint256 indexed winningBid,
        address nftAddress,
        uint256 tokenId
    );

    constructor(address _dedicatedMsgSender) {
        dedicatedMsgSender = _dedicatedMsgSender;
    }

    function createAuction(address nftAddress, uint256 tokenId, uint256 startingPrice) external {
        uint256 newAuctionId = s_auctionIdCounter++;
        s_auctions[newAuctionId] = Auction({
            seller: msg.sender,
            highestBidder: address(0),
            nftAddress: nftAddress,
            tokenId: tokenId,
            startingPrice: startingPrice,
            highestBid: 0,
            startTime: block.timestamp,
            endTime: block.timestamp + DURATION
        });

        IERC721(nftAddress).safeTransferFrom(msg.sender, address(this), tokenId);
    }

    function auctionIdsLength() external view returns (uint256) {
        return s_auctionIdCounter;
    }

    function getAuction(
        uint256 auctionId
    )
        external
        view
        returns (
            address seller,
            address highestBidder,
            address nftAddress,
            uint256 tokenId,
            uint256 startingPrice,
            uint256 highestBid,
            uint256 startTime,
            uint256 endTime
        )
    {
        Auction storage auction = s_auctions[auctionId];
        return (
            auction.seller,
            auction.highestBidder,
            auction.nftAddress,
            auction.tokenId,
            auction.startingPrice,
            auction.highestBid,
            auction.startTime,
            auction.endTime
        );
    }

    function endAuction(uint256 auctionId) external {
        require(msg.sender == dedicatedMsgSender, "Caller is not Gelato");

        Auction storage auction = s_auctions[auctionId];
        require(block.timestamp >= auction.endTime, "Auction has not ended yet");

        if (auction.highestBidder != address(0)) {
            IERC721(auction.nftAddress).safeTransferFrom(address(this), auction.highestBidder, auction.tokenId);
            (bool sellerPaid,) = payable(auction.seller).call{ value: auction.highestBid }("");
            if (!sellerPaid) revert MarketPlace__TransferFailed();
        } else {
            // No bids were placed, return NFT to the seller
            IERC721(auction.nftAddress).safeTransferFrom(address(this), auction.seller, auction.tokenId);
        }

        emit AuctionEnded(auctionId, auction.highestBidder, auction.highestBid, auction.nftAddress, auction.tokenId);

        delete s_auctions[auctionId];
    }

    function placeMockBid(uint256 auctionId, address bidder) external payable {
        Auction storage auction = s_auctions[auctionId];
        require(msg.value > auction.highestBid, "Bid too low");
        auction.highestBidder = bidder;
        auction.highestBid = msg.value;
    }

    function onERC721Received(
        address, /*operator*/
        address, /*from*/
        uint256, /*tokenId*/
        bytes calldata /*data*/
    )
        external
        pure
        override
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }
}
