// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title MarketPlace
 * @author Shawn Rizo
 * @notice This contract will manage the listing, buying, and selling of NFTs on the marketplace.
 * It will interact with NFT contracts to transfer ownership of NFTs when a sale is made.
 * This contract will also handle the listing of NFTs for sale, the bidding process, and the settlement of sales.
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

    // Mapping from NFT contract address and token ID to Listing for quick lookup
    mapping(address => mapping(uint256 => Listing)) private s_listings;

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
     * @dev Checks ownership, prevents zero pricing, and duplicates listings.
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
     * @dev Ensures the caller is the seller.
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
     * @dev Transfers the NFT to the buyer, removes the listing, and updates seller proceeds.
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
     * @dev Ensures the caller has proceeds to withdraw and resets the withdrawal amount.
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

    //////////////////////////////////////
    // Public/External View Functions   //
    //////////////////////////////////////
    /**
     * @notice Returns the listing information for an NFT.
     * @param nftContract The address of the NFT contract.
     * @param tokenId The ID of the NFT.
     * @return The listing information for the given NFT.
     */
    function getListing(address nftContract, uint256 tokenId) external view returns (Listing memory) {
        return s_listings[nftContract][tokenId];
    }

    /**
     * @notice Returns the total proceeds earned by a seller.
     * @param seller The address of the seller.
     * @return The total proceeds earned by the seller.
     */
    function getSellerProceeds(address seller) external view returns (uint256) {
        return proceeds[seller];
    }
}
