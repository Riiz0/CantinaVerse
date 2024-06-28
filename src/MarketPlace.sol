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
    //////////////////
    // Errors       //
    //////////////////
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
    constructor(address initialOwner) Ownable(initialOwner) { }

    /////////////////////////////////
    // External/Public Functions   //
    /////////////////////////////////

    /**
     *
     * @param nftContract is the address of the NFT
     * @param tokenId is the unique identifier of the NFT
     * @param price is the price at which the NFT is listed
     * @notice This function is used to list an NFT for sale. The owner of the NFT must be the msg.sender.
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

        // Update the listing mapping with the new listing
        s_listings[nftContract][tokenId] = Listing(price, msg.sender);

        emit NFTListed(msg.sender, nftContract, tokenId, price);
    }

    /**
     *
     * @param nftContract is the address of the NFT
     * @param tokenId is the unique identifier of the NFT
     * @notice This function is used to delist an NFT for sale. The owner of the NFT must be the msg.sender.
     */
    function delistNFT(address nftContract, uint256 tokenId) external {
        Listing memory listing = s_listings[nftContract][tokenId];
        address seller = listing.seller;
        // Ensure that the caller is the seller of the NFT
        if (msg.sender != seller) {
            revert MarketPlace__NotTheSeller(nftContract, tokenId);
        }

        // Remove the listing to prevent it from being bought
        delete s_listings[nftContract][tokenId];

        // Emit an event for the delisting
        emit NFTDelisted(seller, nftContract, tokenId);
    }

    /**
     *
     * @param tokenId is the unique identifier of the NFT
     * @notice This function is used to buy an NFT that is listed on the marketplace. The buyer has to send the exact
     * amount the seller listed the nft for. The NFT must not have been sold already, then it would revert. If the
     * msg.value != to the listing price then the buyer cant buy the NFT.
     * If the buyer sends the exact amount, then the NFT is transferred to the buyer and the seller receives the funds.
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

        // Remove the listing before transferring to prevent reentrancy
        delete s_listings[nftContract][tokenId];

        // Add the sale proceeds to the seller's balance
        proceeds[seller] += msg.value;

        // Transfer the NFT to the buyer
        IERC721(nftContract).safeTransferFrom(seller, msg.sender, tokenId);

        // Emit an event for the sale
        emit NFTSold(msg.sender, nftContract, tokenId, listing.price);
    }

    /**
     *
     * @notice This function is used to withdraw proceeds from the marketplace
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
     *
     * @param nftContract is the address of the NFT
     * @param tokenId is the unique identifier of the NFT
     * @notice This function is used to get the listing of an NFT
     */
    function getListing(address nftContract, uint256 tokenId) external view returns (Listing memory) {
        return s_listings[nftContract][tokenId];
    }

    /**
     *
     * @param seller is the address of the seller
     * @notice This function is used to get the seller's proceeds
     */
    function getSellerProceeds(address seller) external view returns (uint256) {
        return proceeds[seller];
    }
}
