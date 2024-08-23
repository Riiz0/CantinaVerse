// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title NFTContract
 * @author Shawn Rizo
 * @notice This contract supports creating, managing, and minting ERC721 tokens with built-in royalty information
 * following the ERC2981 standard. It includes functionality to cap the supply of tokens, update royalty
 * information, and manage token metadata.
 * @dev Implements an ERC721 token with extensions for enumerable, URI storage, and royalty management (ERC2981).
 * It allows for the minting of unique digital assets (NFTs) with a capped supply and the ability to set and update
 * royalty information. Ownership and access control are managed through the OpenZeppelin Ownable contract.
 */
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC2981 } from "@openzeppelin/contracts/token/common/ERC2981.sol";
import { ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract NFTContract is ERC721, ERC2981, ERC721Enumerable, ERC721URIStorage, Ownable, ReentrancyGuard {
    /////////////
    // Errors  //
    /////////////
    error NFTContract__InsufficientFunds();
    error NFTContract__MaxSupplyReached();
    error NFTContract__MaxRoyaltyPercentageReached();

    //////////////////////
    // State Variables  //
    //////////////////////
    uint256 private s_nextTokenId;
    string private s_baseURI = "https://silver-selective-kite-794.mypinata.cloud/ipfs/";
    uint256 private immutable i_maxSupply;
    uint96 private constant MAX_ROYALTY_PERCENTAGE = 3000; // 30% => (30 / 100) * 10000 = 3000
    uint96 private s_royaltyPercentage;
    uint256 private s_mintPrice;

    //////////////
    // Events   //
    //////////////
    event NewTokenMinted(address indexed to, uint256 indexed tokenId, string indexed uri, uint256 mintPrice);
    event RoyaltyInfoUpdated(address indexed recipient, uint96 indexed feeNumerator);

    //////////////////
    // Functions    //
    //////////////////
    /**
     * @dev Initializes the contract with specified parameters, setting up the NFT's name, symbol, base URI, max supply,
     *      initial owner, and royalty percentage. Validates the initial royalty percentage against the maximum allowed.
     * @param name Name of the NFT collection.
     * @param symbol Symbol of the NFT collection.
     * @param maxSupply Maximum number of tokens that can be minted.
     * @param initialOwner Address of the initial owner, who is also set as the default royalty recipient.
     * @param royaltyPercentage Initial royalty percentage for secondary sales.
     */
    constructor(
        string memory name,
        string memory symbol,
        uint256 maxSupply,
        address initialOwner,
        uint96 royaltyPercentage,
        uint256 mintPrice
    )
        ERC721(name, symbol)
        Ownable(initialOwner)
    {
        if (royaltyPercentage > MAX_ROYALTY_PERCENTAGE) {
            revert NFTContract__MaxRoyaltyPercentageReached();
        }
        i_maxSupply = maxSupply;
        s_royaltyPercentage = royaltyPercentage;
        _setDefaultRoyalty(initialOwner, s_royaltyPercentage);
        s_mintPrice = mintPrice;
    }

    /////////////////////////////////
    // External/Public Functions   //
    /////////////////////////////////
    /**
     * @notice Safely mints a new NFT and assigns it to `to` address if the max supply hasn't been reached.
     * @dev Mints a new token to the `to` address with a `tokenId` incremented from `s_nextTokenId`. Sets the token's
     * URI to `uri`. Reverts if the max supply is reached.
     * @param to The address to receive the newly minted NFT.
     * @param uri The URI for the NFT metadata.
     * Emits a `NewTokenMinted` event upon successful minting.
     */
    function safeMint(address to, string memory uri) external payable nonReentrant {
        if (s_mintPrice > 0 && msg.value < s_mintPrice) {
            revert NFTContract__InsufficientFunds();
        }
        if (s_nextTokenId > i_maxSupply) {
            revert NFTContract__MaxSupplyReached();
        }
        uint256 tokenId = s_nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        // Transfer the minting fees to the owner
        if (msg.value > 0) {
            (bool success,) = payable(owner()).call{ value: msg.value }("");
            require(success, "Transfer failed");
        }

        emit NewTokenMinted(to, tokenId, uri, s_mintPrice);
    }

    /**
     * @notice Updates the royalty information for the NFT contract to `newRoyaltyPercentage` for `contractOwner`.
     * @dev Only callable by the contract owner. Sets the royalty percentage to `newRoyaltyPercentage` and updates the
     * default royalty info. Reverts if the new royalty percentage exceeds `MAX_ROYALTY_PERCENTAGE`.
     * @param contractOwner The address of the contract owner.
     * @param newRoyaltyPercentage The new royalty percentage to be set.
     * Emits a `RoyaltyInfoUpdated` event upon successful update.
     */
    function updateRoyaltyInfo(address contractOwner, uint96 newRoyaltyPercentage) external onlyOwner {
        if (newRoyaltyPercentage > MAX_ROYALTY_PERCENTAGE) {
            revert NFTContract__MaxRoyaltyPercentageReached();
        }
        s_royaltyPercentage = newRoyaltyPercentage;
        _setDefaultRoyalty(contractOwner, newRoyaltyPercentage);

        emit RoyaltyInfoUpdated(contractOwner, newRoyaltyPercentage);
    }

    /**
     * @notice Sets the base URI for all NFT metadata to `baseURI`.
     * @dev Only callable by the contract owner. Updates `s_baseURI` with the new base URI.
     * @param baseURI The new base URI to be set for all token metadata.
     */
    function setBaseURI(string memory baseURI) external onlyOwner {
        s_baseURI = baseURI;
    }

    //////////////////////////////////////
    // External/Public View Functions   //
    //////////////////////////////////////
    /**
     * @notice Returns the maximum supply of NFTs that can be minted.
     * @return uint256 The maximum supply of the NFT.
     */
    function getMaxSupply() external view returns (uint256) {
        return i_maxSupply;
    }

    /**
     * @notice Returns the current royalty percentage for the NFT contract.
     * @return uint96 The current royalty percentage.
     */
    function getRoyaltyPercentage() external view returns (uint96) {
        return s_royaltyPercentage;
    }

    /**
     * @notice Returns the base URI set for NFT metadata.
     * @return string memory The base URI for the NFT metadata.
     */
    function getBaseURI() external view returns (string memory) {
        return s_baseURI;
    }

    function getMintPrice() external view returns (uint256) {
        return s_mintPrice;
    }

    ////////////////////////////////////////////////////////////
    // The following functions are overrides required by Solidity //
    ////////////////////////////////////////////////////////////
    /**
     * @dev Overrides the base URI for token metadata. Used internally to construct the full URI for a given token.
     * @return string memory The base URI set for the contract.
     */
    function _baseURI() internal view override returns (string memory) {
        return s_baseURI;
    }

    /**
     * @dev Overrides the default implementation of the `_update` function to transfer a token between addresses.
     * @param to The address to transfer the token to.
     * @param tokenId The ID of the token to transfer.
     * @param auth The authorization address, used for validation.
     * @return address The address of the new owner of the token.
     */
    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    /**
     * @dev Overrides the default implementation of the `_increaseBalance` function to increase the balance of an
     * account.
     * @param account The account whose balance will be increased.
     * @param value The amount by which the balance will be increased.
     */
    function _increaseBalance(address account, uint128 value) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    /**
     * @dev Overrides the default implementation of the `tokenURI` function to return the URI for a given token's
     * metadata.
     * @param tokenId The ID of the token.
     * @return string memory The URI for the token's metadata.
     */
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev Overrides the default implementation of the `supportsInterface` function to check if the contract supports a
     * given interface.
     * @param interfaceId The ID of the interface to check support for.
     * @return bool Whether the contract supports the specified interface.
     */
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC2981, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
