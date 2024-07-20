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
    error MarketPlace__TransferFailed();
    error MarketPlace__NotTheSeller(address nftContract, uint256 tokenId);

    //////////////////////
    // State Variables  //
    //////////////////////
    struct Listing {
        uint256 price;
        address seller;
    }

    struct Auction {
        uint256 startingPrice;
        uint256 highestBid;
        address highestBidder;
        uint256 startTime;
        uint256 endTime;
        bool active;
    }

    mapping(address => mapping(uint256 => Listing)) private s_listings;
    mapping(address => mapping(uint256 => Auction)) private s_auctions;

    // Mapping to track seller proceeds from sales
    mapping(address => uint256) private proceeds;

    //////////////
    // Events   //
    //////////////
    event NFTListed(address indexed seller, address indexed nftContract, uint256 indexed tokenId, uint256 price);
    event NFTDelisted(address indexed seller, address indexed nftContract, uint256 indexed tokenId);
    event NFTSold(address indexed buyer, address indexed nftContract, uint256 indexed tokenId, uint256 price);
    event NewNFTListingPrice(
        address indexed seller, address indexed nftContract, uint256 indexed tokenId, uint256 newPrice
    );
    event ProceedsWithdrawn(address indexed seller, uint256 indexed amount);
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
    constructor(address initialOwner) Ownable(initialOwner) { }

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
        IERC721 nft = IERC721(nftContract);
        if (price == 0) {
            revert MarketPlace__PriceCannotBeZero();
        }

        if (nft.ownerOf(tokenId) != msg.sender) {
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
        IERC721 nft = IERC721(nftContract);
        Listing storage listing = s_listings[nftContract][tokenId];
        uint256 amount = listing.price;
        if (msg.value != amount) {
            revert MarketPlace__InsufficientFundsOrExcessFundsToPurchase(nftContract, tokenId, amount);
        }

        address seller = listing.seller;
        if (nft.ownerOf(tokenId) != seller) {
            revert MarketPlace__NotTheSeller(nftContract, tokenId);
        }

        delete s_listings[nftContract][tokenId];
        proceeds[seller] += msg.value;
        IERC721(nftContract).safeTransferFrom(seller, msg.sender, tokenId);

        emit NFTSold(msg.sender, nftContract, tokenId, listing.price);
    }

    /**
     * @notice Withdraws proceeds from sales.
     * @dev Ensures the caller has proceeds to withdraw and resets the withdrawal amount. Emits a ProceedsWithdrawn
     * event upon successful withdrawal.
     */
    function withdrawProceeds() external nonReentrant {
        uint256 amount = proceeds[msg.sender];
        if (amount <= 0) revert MarketPlace__NoProceeds();

        proceeds[msg.sender] = 0;

        // Transfer the proceeds to the seller
        (bool success,) = payable(msg.sender).call{ value: amount }("");
        if (!success) revert MarketPlace__TransferFailed();

        emit ProceedsWithdrawn(msg.sender, amount);
    }

    // Function to create an auction
    function createAuction(address nftContract, uint256 tokenId, uint256 startingPrice, uint256 duration) external {
        // Require that the NFT is not already listed or part of an active auction
        // Transfer the NFT to the contract for escrow
        // Set the auction details in `s_auctions`
        // Emit AuctionCreated event
    }

    // Function to bid on an auction
    function bidOnAuction(address nftContract, uint256 tokenId) external payable {
        // Require that the auction is active
        // Require that the bid is higher than the current highest bid
        // Refund the previous highest bidder
        // Update the highest bid and bidder
        // Emit BidPlaced event
    }

    // Function to end an auction
    function endAuction(address nftContract, uint256 tokenId) external {
        // Require that the auction end time has passed
        // Transfer the NFT to the highest bidder
        // Transfer the highest bid to the seller
        // Mark the auction as inactive
        // Emit AuctionEnded event
    }

    //////////////////////////////////////
    // Public/External View Functions   //
    //////////////////////////////////////
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
     * @notice Returns the total proceeds earned by a seller.
     * @dev Provides read-only access to seller proceeds.
     * @param seller The address of the seller.
     * @return The total proceeds earned by the seller.
     */
    function getSellerProceeds(address seller) external view returns (uint256) {
        return proceeds[seller];
    }
}
