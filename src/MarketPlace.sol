// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

/**
 * @title MarketPlace
 * @author Shawn Rizo
 * @notice This contract will manage the listing, buying, and selling of NFTs on your marketplace.
 * It will interact with the NFT contract to transfer ownership of NFTs when a sale is made.
 * This contract will also handle the listing of NFTs for sale, the bidding process, and the settlement of sales.
 */
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract MarketPlace is Ownable, ReentrancyGuard {
    //////////////////
    // Errors       //
    //////////////////
    error MarketPlace__ListNFTNotTheOwner();
    error MarketPlace__AlreadyListed();
    error MarketPlace__AlreadySold();
    error MarketPlace__InsufficientFundsOrExcessFundsToPurchase();
    error MarketPlace__NotSeller();
    error MarketPlace__CannotUpdateSoldListing();

    //////////////////////
    // State Variables  //
    //////////////////////

    struct Listing {
        uint256 listingId;
        address nftCollection;
        uint256 tokenId;
        address payable seller;
        uint256 price;
        bool isSold;
        bool exists;
    }

    mapping(uint256 => Listing) private s_listings;
    uint256 private s_lastListingId;

    //////////////
    // Events   //
    //////////////
    event ListingCreated(
        uint256 indexed listingId, address indexed nftCollection, uint256 indexed tokenId, address seller, uint256 price
    );

    event NFTPurchased(uint256 indexed listingId, address indexed buyer, uint256 indexed price);

    //////////////////
    // Functions    //
    //////////////////

    ///////////////////////////
    // Internal Functions    //
    ///////////////////////////
    function generateUniqueListingId() internal returns (uint256) {
        s_lastListingId += 1; // Increment the last used listing ID
        return s_lastListingId;
    }

    constructor(address initialOwner) Ownable(initialOwner) { }

    /////////////////////////////////
    // External/Public Functions   //
    /////////////////////////////////
    function listNFT(uint256 tokenId, address nftCollection, uint256 price) public {
        IERC721 INFTStandard = IERC721(nftCollection);
        address currentOwner = INFTStandard.ownerOf(tokenId);

        if (msg.sender != currentOwner) {
            revert MarketPlace__ListNFTNotTheOwner();
        }
        Listing storage existingListing = s_listings[tokenId];
        if (existingListing.exists) {
            revert MarketPlace__AlreadyListed();
        }

        // Generate a unique listingId
        uint256 listingId = generateUniqueListingId(); // Implement this function based on your requirements

        // List the NFT on the platform
        Listing memory newListing = Listing({
            listingId: listingId,
            nftCollection: nftCollection,
            tokenId: tokenId,
            seller: payable(msg.sender),
            price: price,
            isSold: false,
            exists: true
        });
        s_listings[listingId] = newListing;

        // Emit the ListingCreated event
        emit ListingCreated(
            newListing.listingId, newListing.nftCollection, newListing.tokenId, newListing.seller, newListing.price
        );
    }

    function updatePrice(uint256 tokenId, uint256 newPrice) public {
        Listing storage listing = s_listings[tokenId];
        if (msg.sender != listing.seller) {
            revert MarketPlace__NotSeller();
        }

        if (listing.isSold) {
            revert MarketPlace__CannotUpdateSoldListing();
        }
        listing.price = newPrice;
    }

    function buyNFT(uint256 tokenId) public payable nonReentrant {
        Listing storage listing = s_listings[tokenId];
        if (listing.isSold) {
            revert MarketPlace__AlreadySold();
        }

        if (msg.value != listing.price) {
            revert MarketPlace__InsufficientFundsOrExcessFundsToPurchase();
        }

        IERC721 INFTStandard = IERC721(listing.nftCollection);
        INFTStandard.safeTransferFrom(listing.seller, msg.sender, listing.tokenId);

        listing.isSold = true;
        listing.seller.transfer(listing.price);

        emit NFTPurchased(listing.listingId, msg.sender, listing.price);
    }

    //////////////////////////////////////
    // Public/External View Functions   //
    //////////////////////////////////////

    function getListingDetails(uint256 listingId) public view returns (Listing memory) {
        return s_listings[listingId];
    }
}
