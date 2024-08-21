// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { IERC721Receiver } from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract MarketPlace is Ownable, ReentrancyGuard, IERC721Receiver {
    /////////////
    // Errors  //
    /////////////
    error MarketPlace__CallerIsNotGelato();
    error MarketPlace__PriceCannotBeZero();
    error MarketPlace__NFTAlreadyListedOrInAuction();
    error MarketPlace__ListNFTNotTheOwner();
    error MarketPlace__NFTNotListed();
    error MarketPlace__InsufficientFundsOrExcessFundsToPurchase();
    error MarketPlace__TransferFailed();
    error MarketPlace__AuctionNotTheOwner();
    error MarketPlace__NFTNotInAuction();
    error MarketPlace__BidIsLessThanHighestBid();
    error MarketPlace__NFTInAuctionStatus();
    error MarketPlace__NFTAuctionHasEnded();
    error MarketPlace__NFTAuctionHasNotEnded();
    error MarketPlace__CantBeZeroAmount();
    error MarketPlace__CantBeZeroAddress();
    error MarketPlace__InvalidListingId();

    //////////////////////
    // State Variables  //
    //////////////////////

    struct Listing {
        address seller;
        address nftAddress;
        uint256 tokenId;
        uint256 price;
    }

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

    enum NFTStatus {
        None,
        Listed,
        InAuction
    }

    mapping(address => mapping(uint256 => NFTStatus)) private s_nftStatuses;
    mapping(uint256 => Listing) private s_listings;
    mapping(uint256 => Auction) private s_auctions;

    uint256 private s_listingIdCounter;
    uint256 private s_auctionIdCounter;
    address private s_GelatoDedicatedMsgSender;
    uint256 private s_fee;
    uint256 private constant DURATION = 3 days;

    //////////////
    // Events   //
    //////////////
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
    event NewGelatoDedicatedMsgSender(address indexed newGelatoAddress);

    //////////////////
    // Functions    //
    //////////////////
    /**
     * @dev Constructor sets the initial owner of the contract.
     * @param initialOwner The address of the initial owner.
     */
    constructor(address initialOwner, address _GelatoDedicatedMsgSender, uint256 _setFee) Ownable(initialOwner) {
        if (_GelatoDedicatedMsgSender == address(0)) {
            revert MarketPlace__CantBeZeroAddress();
        }
        s_GelatoDedicatedMsgSender = _GelatoDedicatedMsgSender;
        s_fee = _setFee;
    }

    /////////////////////////////////
    // External/Public Functions   //
    /////////////////////////////////
    function listNFT(address nftAddress, uint256 tokenId, uint256 price) external {
        if (s_nftStatuses[nftAddress][tokenId] != NFTStatus.None) {
            revert MarketPlace__NFTAlreadyListedOrInAuction();
        }
        if (IERC721(nftAddress).ownerOf(tokenId) != msg.sender) {
            revert MarketPlace__ListNFTNotTheOwner();
        }
        if (price == 0) {
            revert MarketPlace__PriceCannotBeZero();
        }
        uint256 newListingId = s_listingIdCounter++;
        s_listings[newListingId] =
            Listing({ seller: msg.sender, nftAddress: nftAddress, tokenId: tokenId, price: price });
        s_nftStatuses[nftAddress][tokenId] = NFTStatus.Listed;

        emit NFTListed(msg.sender, nftAddress, tokenId, price);
    }

    function delistNFT(uint256 listingId) external {
        Listing storage listing = s_listings[listingId];
        address nftAddress = listing.nftAddress;
        uint256 tokenId = listing.tokenId;
        if (s_nftStatuses[listing.nftAddress][listing.tokenId] != NFTStatus.Listed) {
            revert MarketPlace__NFTNotListed();
        }

        s_listingIdCounter--;
        s_nftStatuses[listing.nftAddress][listing.tokenId] = NFTStatus.None;
        delete s_listings[listingId];

        emit NFTDelisted(msg.sender, nftAddress, tokenId);
    }

    function buyNFT(uint256 listingId) external payable nonReentrant {
        Listing storage listing = s_listings[listingId];
        address seller = listing.seller;
        address nftAddress = listing.nftAddress;
        uint256 tokenId = listing.tokenId;
        uint256 price = listing.price;
        uint256 totalCost = price + s_fee;

        if (s_nftStatuses[listing.nftAddress][listing.tokenId] != NFTStatus.Listed) {
            revert MarketPlace__NFTNotListed();
        }
        if (msg.value != totalCost) {
            revert MarketPlace__InsufficientFundsOrExcessFundsToPurchase();
        }

        s_listingIdCounter--;
        s_nftStatuses[listing.nftAddress][listing.tokenId] = NFTStatus.None;
        delete s_listings[listingId];

        IERC721(nftAddress).safeTransferFrom(seller, msg.sender, tokenId);

        (bool success,) = payable(seller).call{ value: price }("");
        if (!success) revert MarketPlace__TransferFailed();

        emit NFTSold(msg.sender, nftAddress, tokenId, price);
    }

    function createAuction(address nftAddress, uint256 tokenId, uint256 startingPrice) external {
        if (s_nftStatuses[nftAddress][tokenId] != NFTStatus.None) {
            revert MarketPlace__NFTAlreadyListedOrInAuction();
        }
        if (IERC721(nftAddress).ownerOf(tokenId) != msg.sender) {
            revert MarketPlace__AuctionNotTheOwner();
        }
        if (startingPrice == 0) {
            revert MarketPlace__PriceCannotBeZero();
        }

        uint256 endTime = block.timestamp + DURATION;
        uint256 newAuctionId = s_auctionIdCounter++;
        s_auctions[newAuctionId] = Auction({
            seller: msg.sender,
            highestBidder: address(0),
            nftAddress: nftAddress,
            tokenId: tokenId,
            startingPrice: startingPrice,
            highestBid: 0,
            startTime: block.timestamp,
            endTime: endTime
        });
        s_nftStatuses[nftAddress][tokenId] = NFTStatus.InAuction;

        IERC721(nftAddress).safeTransferFrom(msg.sender, address(this), tokenId);

        emit AuctionCreated(newAuctionId, block.timestamp, endTime, nftAddress, tokenId, startingPrice);
    }

    function bidOnAuction(uint256 auctionId) external payable nonReentrant {
        Auction storage auction = s_auctions[auctionId];
        if (s_nftStatuses[auction.nftAddress][auction.tokenId] != NFTStatus.InAuction) {
            revert MarketPlace__NFTInAuctionStatus();
        }
        if (block.timestamp >= auction.endTime) {
            revert MarketPlace__NFTAuctionHasEnded();
        }
        if (msg.value <= auction.highestBid) {
            revert MarketPlace__BidIsLessThanHighestBid();
        }

        address previousHighestBidder = auction.highestBidder;
        uint256 previousHighestBid = auction.highestBid;

        auction.highestBid = msg.value;
        auction.highestBidder = msg.sender;

        if (previousHighestBidder != address(0)) {
            // Refund the previous highest bidder
            (bool refundSuccess,) = payable(previousHighestBidder).call{ value: previousHighestBid }("");
            if (!refundSuccess) revert MarketPlace__TransferFailed();
        }

        emit BidPlaced(auctionId, msg.sender, msg.value, auction.nftAddress, auction.tokenId);
    }

    function endAuction(uint256 auctionId) external nonReentrant {
        if (msg.sender != s_GelatoDedicatedMsgSender) {
            revert MarketPlace__CallerIsNotGelato();
        }

        Auction storage auction = s_auctions[auctionId];
        if (s_nftStatuses[auction.nftAddress][auction.tokenId] != NFTStatus.InAuction) {
            revert MarketPlace__NFTNotInAuction();
        }
        if (block.timestamp < auction.endTime) {
            revert MarketPlace__NFTAuctionHasNotEnded();
        }

        address highestBidder = auction.highestBidder;
        address seller = auction.seller;
        address nftAddress = auction.nftAddress;
        uint256 tokenId = auction.tokenId;
        uint256 highestBid = auction.highestBid;

        s_auctionIdCounter--;
        s_nftStatuses[auction.nftAddress][auction.tokenId] = NFTStatus.None;
        delete s_auctions[auctionId];

        if (highestBidder != address(0)) {
            IERC721(nftAddress).safeTransferFrom(address(this), highestBidder, tokenId);
            (bool sellerPaid,) = payable(seller).call{ value: highestBid }("");
            if (!sellerPaid) revert MarketPlace__TransferFailed();
        } else {
            // No bids were placed, return NFT to the seller
            IERC721(nftAddress).safeTransferFrom(address(this), seller, tokenId);
        }

        emit AuctionEnded(auctionId, highestBidder, highestBid, nftAddress, tokenId);
    }

    function setNewGelatoDedicatedMsgSender(address _newDedicatedMsgSender) external onlyOwner {
        if (_newDedicatedMsgSender == address(0)) {
            revert MarketPlace__CantBeZeroAddress();
        }

        s_GelatoDedicatedMsgSender = _newDedicatedMsgSender;
        emit NewGelatoDedicatedMsgSender(_newDedicatedMsgSender);
    }

    function setFee(uint256 _fee) external onlyOwner {
        s_fee = _fee;
        emit FeeUpdated(_fee);
    }

    function withdraw(address payable recipient, uint256 amount) external onlyOwner {
        if (recipient == address(0)) {
            revert MarketPlace__CantBeZeroAddress();
        }
        if (amount == 0) {
            revert MarketPlace__CantBeZeroAmount();
        }

        (bool success,) = recipient.call{ value: amount }("");
        if (!success) revert MarketPlace__TransferFailed();
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

    //////////////////////////////////////
    // Public/External View Functions   //
    //////////////////////////////////////
    /**
     * @notice Returns the current fee for creating a new NFT collection.
     * @dev Provides a view function to see the current fee required to create a new NFT collection.
     * @return The fee amount in wei required to create a new NFT collection.
     */
    function getFee() external view returns (uint256) {
        return s_fee;
    }

    function getListingDetails(
        uint256 listingId
    )
        external
        view
        returns (address seller, address nftAddress, uint256 tokenId, uint256 price)
    {
        if (listingId > s_listingIdCounter) {
            revert MarketPlace__InvalidListingId();
        }
        Listing storage listing = s_listings[listingId];
        return (listing.seller, listing.nftAddress, listing.tokenId, listing.price);
    }

    function getCurrentListingIdCounter() external view returns (uint256) {
        return s_listingIdCounter;
    }

    function getNFTStatus(address nftAddress, uint256 tokenId) external view returns (NFTStatus) {
        return s_nftStatuses[nftAddress][tokenId];
    }

    function auctionIdsLength() external view returns (uint256) {
        return s_auctionIdCounter;
    }

    function getAuction(
        uint256 auctionId
    )
        public
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
}
