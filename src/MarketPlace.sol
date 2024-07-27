// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title MarketPlace
 * @author Shawn Rizo
 * @notice This contract manages the listing, buying, and selling of NFTs on a marketplace. It allows users to list
 * their NFTs for sale, delist them, purchase NFTs listed by others, and withdraw proceeds from sales. The contract
 * ensures secure transactions by verifying ownership, preventing reentrancy attacks, and validating transaction
 * conditions.
 * @dev The contract uses OpenZeppelin's IERC721 for NFT interactions, Ownable for ownership management, and
 * ReentrancyGuard for preventing reentrancy attacks. It defines custom errors for various failure conditions, maintains
 * a mapping of NFT listings and seller proceeds, and emits events for significant actions.
 */
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract MarketPlace is Ownable, ReentrancyGuard {
    /////////////
    // Errors  //
    /////////////
    error MarketPlace__ListNFTNotTheOwner();
    error MarketPlace__PriceCannotBeZero();
    error MarketPlace__AlreadyListed();
    error MarketPlace__InsufficientFundsOrExcessFundsToPurchase(address nftContract, uint256 tokenId, uint256 price);
    error MarketPlace__NoProceeds();
    error MarketPlace__InsufficientFees();
    error MarketPlace__TransferFailed();
    error MarketPlace__NotTheSeller(address nftContract, uint256 tokenId);
    error MarketPlace__AuctionNotTheOwner();
    error MarketPlace__NFTAlreadyInAuction();
    error MarketPlace__StartingPriceMustBeGreaterThanZero();
    error MarketPlace__NFTAuctionIsNotActive();
    error MarketPlace__BidIsLessThanHighestBid();
    error MarketPlace__NFTAuctionHasEnded();

    //////////////////////
    // State Variables  //
    //////////////////////

    struct Listing {
        uint256 price;
        address seller;
    }

    struct Auction {
        address seller;
        uint256 startingPrice;
        uint256 highestBid;
        address highestBidder;
        uint256 startTime;
        uint256 endTime;
        bool active;
    }

    mapping(address => mapping(uint256 => Listing)) private s_listings;
    mapping(address => mapping(uint256 => Auction)) private s_auctions;
    address private gelatoAddress;
    uint256 private s_fee; // Fee required to buy an NFT

    //////////////
    // Events   //
    //////////////
    event NFTListed(address indexed seller, address indexed nftContract, uint256 indexed tokenId, uint256 price);
    event NFTDelisted(address indexed seller, address indexed nftContract, uint256 indexed tokenId);
    event NFTSold(address indexed buyer, address indexed nftContract, uint256 indexed tokenId, uint256 price);
    event AuctionCreated(
        address indexed nftContract, uint256 indexed tokenId, uint256 startingPrice, uint256 startTime, uint256 endTime
    );
    event BidPlaced(address indexed nftContract, uint256 indexed tokenId, address bidder, uint256 bid);
    event AuctionEnded(address indexed nftContract, uint256 indexed tokenId, address winner, uint256 winningBid);

    //////////////////
    // Functions    //
    //////////////////
    /**
     * @dev Constructor sets the initial owner of the contract.
     * @param initialOwner The address of the initial owner.
     */
    constructor(address initialOwner, address _gelatoAddress) Ownable(initialOwner) {
        gelatoAddress = _gelatoAddress;
    }

    modifier onlyGelato() {
        require(msg.sender == gelatoAddress, "Caller is not Gelato");
        _;
    }

    /////////////////////////////////
    // External/Public Functions   //
    /////////////////////////////////
    /**
     * @notice Lists an NFT for sale on the marketplace.
     * @dev Checks ownership, prevents zero pricing, and duplicates listings. Emits an NFTListed event upon successful
     * listing.
     * @param nftContract The address of the NFT contract.
     * @param tokenId The ID of the NFT to be listed.
     * @param price The price at which the NFT should be listed.
     */
    function listNFT(address nftContract, uint256 tokenId, uint256 price) external {
        if (price == 0) {
            revert MarketPlace__PriceCannotBeZero();
        }

        if (IERC721(nftContract).ownerOf(tokenId) != msg.sender) {
            revert MarketPlace__ListNFTNotTheOwner();
        }

        if (s_listings[nftContract][tokenId].price > 0) {
            revert MarketPlace__AlreadyListed();
        }

        s_listings[nftContract][tokenId] = Listing(price, msg.sender);

        emit NFTListed(msg.sender, nftContract, tokenId, price);
    }

    /**
     * @notice Delists an NFT from the marketplace.
     * @dev Ensures the caller is the seller. Emits an NFTDelisted event upon successful delisting.
     * @param nftContract The address of the NFT contract.
     * @param tokenId The ID of the NFT to be delisted.
     */
    function delistNFT(address nftContract, uint256 tokenId) external {
        Listing memory listing = s_listings[nftContract][tokenId];
        address seller = listing.seller;

        if (msg.sender != seller) {
            revert MarketPlace__NotTheSeller(nftContract, tokenId);
        }

        delete s_listings[nftContract][tokenId];

        emit NFTDelisted(seller, nftContract, tokenId);
    }

    /**
     * @notice Buys an NFT from the marketplace.
     * @dev Transfers the NFT to the buyer, removes the listing, and updates seller proceeds. Emits an NFTSold event
     * upon successful transaction.
     * @param nftContract The address of the NFT contract.
     * @param tokenId The ID of the NFT to be purchased.
     */
    function buyNFT(address nftContract, uint256 tokenId) external payable nonReentrant {
        Listing storage listing = s_listings[nftContract][tokenId];
        uint256 amount = listing.price;
        uint256 serviceFee = s_fee; // Assuming s_fee is the service fee for purchasing an NFT.
        uint256 totalCost = amount + serviceFee;
        if (msg.value != totalCost) {
            revert MarketPlace__InsufficientFundsOrExcessFundsToPurchase(nftContract, tokenId, totalCost);
        }

        address seller = listing.seller;
        if (IERC721(nftContract).ownerOf(tokenId) != seller) {
            revert MarketPlace__NotTheSeller(nftContract, tokenId);
        }

        delete s_listings[nftContract][tokenId];

        IERC721(nftContract).safeTransferFrom(seller, msg.sender, tokenId);
        // Transfer the sale amount to the seller
        (bool success,) = payable(seller).call{ value: amount }("");
        if (!success) revert MarketPlace__TransferFailed();

        emit NFTSold(msg.sender, nftContract, tokenId, listing.price);
    }

    function createAuction(
        address nftContract,
        uint256 tokenId,
        uint256 startingPrice,
        uint256 durationInDays
    )
        external
    {
        if (IERC721(nftContract).ownerOf(tokenId) != msg.sender) {
            revert MarketPlace__AuctionNotTheOwner();
        }
        if (s_listings[nftContract][tokenId].price > 0) {
            revert MarketPlace__AlreadyListed();
        }

        if (s_auctions[nftContract][tokenId].active == true) {
            revert MarketPlace__NFTAlreadyInAuction();
        }
        if (startingPrice == 0) {
            revert MarketPlace__StartingPriceMustBeGreaterThanZero();
        }

        IERC721(nftContract).safeTransferFrom(msg.sender, address(this), tokenId);

        uint256 durationInSeconds = durationInDays * 1 days; // Convert duration from days to seconds
        uint256 endTime = block.timestamp + durationInSeconds; // Calculate endTime based on duration in seconds

        s_auctions[nftContract][tokenId] = Auction({
            seller: msg.sender,
            startingPrice: startingPrice,
            highestBid: 0,
            highestBidder: address(0),
            startTime: block.timestamp,
            endTime: endTime,
            active: true
        });

        emit AuctionCreated(nftContract, tokenId, startingPrice, block.timestamp, endTime);
    }

    function bidOnAuction(address nftContract, uint256 tokenId) external payable nonReentrant {
        Auction storage auction = s_auctions[nftContract][tokenId];
        if (auction.active == false) {
            revert MarketPlace__NFTAuctionIsNotActive();
        }
        if (msg.value < auction.highestBid) {
            revert MarketPlace__BidIsLessThanHighestBid();
        }
        if (auction.highestBidder != address(0)) {
            // Refund the previous highest bidder
            (bool refundSuccess,) = payable(auction.highestBidder).call{ value: auction.highestBid }("");
            if (!refundSuccess) revert MarketPlace__TransferFailed();
        }

        auction.highestBid = msg.value;
        auction.highestBidder = msg.sender;

        emit BidPlaced(nftContract, tokenId, msg.sender, msg.value);
    }

    function endAuction(address nftContract, uint256 tokenId) external onlyGelato nonReentrant {
        Auction storage auction = s_auctions[nftContract][tokenId];
        if (auction.active == false) {
            revert MarketPlace__NFTAuctionIsNotActive();
        }
        if (block.timestamp < auction.endTime) {
            revert MarketPlace__NFTAuctionHasEnded();
        }

        auction.active = false;

        if (auction.highestBidder != address(0)) {
            IERC721(nftContract).safeTransferFrom(address(this), auction.highestBidder, tokenId);
            (bool sellerPaid,) = payable(auction.seller).call{ value: auction.highestBid }("");
            if (!sellerPaid) revert MarketPlace__TransferFailed();
        } else {
            // No bids were placed, return NFT to the seller
            IERC721(nftContract).safeTransferFrom(address(this), auction.seller, tokenId);
        }

        emit AuctionEnded(nftContract, tokenId, auction.highestBidder, auction.highestBid);
    }

    function setGelatoAddress(address _newGelatoAddress) external onlyOwner {
        gelatoAddress = _newGelatoAddress;
    }

    /**
     * @notice Sets the fee required to create a new NFT collection.
     * @dev Can only be called by the contract owner. Updates the fee for creating new NFT collections.
     * @param _fee The new fee amount in wei.
     */
    function setFee(uint256 _fee) external onlyOwner {
        s_fee = _fee;
    }

    /**
     * @notice Withdraws the accumulated fees to the contract owner's address.
     * @dev Transfers the entire balance of the contract to the owner. Can only be called by the owner.
     * @custom:reverts FactoryNFTContract__InsufficientFunds if there are no funds to withdraw.
     */
    function withdraw() external onlyOwner {
        if (address(this).balance == 0) {
            revert MarketPlace__InsufficientFees();
        }
        payable(owner()).transfer(address(this).balance);
    }

    //////////////////////////////////////
    // Public/External View Functions   //
    //////////////////////////////////////
    function checkAuctionEndCondition(
        address nftContract,
        uint256 tokenId
    )
        external
        view
        returns (bool canExec, bytes memory execPayload)
    {
        Auction memory auction = s_auctions[nftContract][tokenId];
        canExec = (auction.active && block.timestamp >= auction.endTime);

        execPayload = canExec ? abi.encodeWithSelector(this.endAuction.selector, nftContract, tokenId) : bytes("");

        return (canExec, execPayload);
    }
    /**
     * @notice Returns the listing information for an NFT.
     * @dev Provides read-only access to NFT listings.
     * @param nftContract The address of the NFT contract.
     * @param tokenId The ID of the NFT.
     * @return The listing information for the given NFT.
     */

    function getListing(address nftContract, uint256 tokenId) external view returns (Listing memory) {
        return s_listings[nftContract][tokenId];
    }

    /**
     * @notice Returns the auction information for an NFT.
     * @dev Provides read-only access to NFT auction.
     * @param nftContract The address of the NFT contract.
     * @param tokenId The ID of the NFT.
     * @return The auction information for the given NFT.
     */
    function getAuction(address nftContract, uint256 tokenId) external view returns (Auction memory) {
        return s_auctions[nftContract][tokenId];
    }

    /**
     * @notice Returns the current fee for creating a new NFT collection.
     * @dev Provides a view function to see the current fee required to create a new NFT collection.
     * @return The fee amount in wei required to create a new NFT collection.
     */
    function getFee() external view returns (uint256) {
        return s_fee;
    }
}
