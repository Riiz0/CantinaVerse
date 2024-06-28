// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title NFTContract
 * @author Shawn Rizo
 * @notice A contract for creating, managing, and minting ERC721 tokens with royalties.
 */
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC2981 } from "@openzeppelin/contracts/token/common/ERC2981.sol";
import { ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract NFTContract is ERC721, ERC2981, ERC721Enumerable, ERC721URIStorage, Ownable {
    /////////////
    // Errors  //
    /////////////
    error NFTContract__MaxSupplyReached();
    error NFTContract__MaxRoyaltyPercentageReached();

    //////////////////////
    // State Variables  //
    //////////////////////
    uint256 private s_nextTokenId;
    string private s_baseURI;
    uint256 private immutable i_maxSupply;
    uint96 private constant MAX_ROYALTY_PERCENTAGE = 3000; // 30% => (30 / 100) * 10000 = 3000
    uint96 private s_royaltyPercentage;

    //////////////
    // Events   //
    //////////////
    event NewTokenMinted(address indexed to, uint256 indexed tokenId, string indexed uri);
    event RoyaltyInfoUpdated(address indexed recipient, uint96 indexed feeNumerator);

    //////////////////
    // Functions    //
    //////////////////
    /**
     * @dev Constructor initializes the contract with the provided parameters.
     * @param name The name of the NFT.
     * @param symbol The symbol of the NFT.
     * @param baseURI The base URI for the NFT metadata.
     * @param maxSupply The maximum supply of the NFT.
     * @param initialOwner The address of the initial owner.
     * @param royaltyPercentage The royalty percentage for the NFT.
     */
    constructor(
        string memory name,
        string memory symbol,
        string memory baseURI,
        uint256 maxSupply,
        address initialOwner,
        uint96 royaltyPercentage
    )
        ERC721(name, symbol)
        Ownable(initialOwner)
    {
        if (royaltyPercentage > MAX_ROYALTY_PERCENTAGE) {
            revert NFTContract__MaxRoyaltyPercentageReached();
        }
        s_baseURI = baseURI;
        i_maxSupply = maxSupply;
        s_royaltyPercentage = royaltyPercentage;
        _setDefaultRoyalty(initialOwner, s_royaltyPercentage);
    }

    /////////////////////////////////
    // External/Public Functions   //
    /////////////////////////////////
    /**
     * @notice Safely mints a new NFT and assigns it to the specified address.
     * @dev Checks if the max supply has been reached before minting.
     * @param to The address to receive the newly minted NFT.
     * @param uri The URI for the NFT metadata.
     */
    function safeMint(address to, string memory uri) external {
        if (s_nextTokenId > i_maxSupply) {
            revert NFTContract__MaxSupplyReached();
        }
        uint256 tokenId = s_nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        emit NewTokenMinted(to, tokenId, uri);
    }

    /**
     * @notice Updates the royalty information for the NFT contract.
     * @dev Only callable by the owner. Checks if the new royalty percentage exceeds the max allowed.
     * @param contractOwner The address of the contract owner.
     * @param newRoyaltyPercentage The new royalty percentage.
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
     * @notice Sets the base URI for the NFT metadata.
     * @dev Only callable by the owner.
     * @param baseURI The new base URI.
     */
    function setBaseURI(string memory baseURI) external onlyOwner {
        s_baseURI = baseURI;
    }

    //////////////////////////////////////
    // External/Public View Functions   //
    //////////////////////////////////////
    /**
     * @notice Returns the maximum supply of the NFT.
     * @return The maximum supply of the NFT.
     */
    function getMaxSupply() external view returns (uint256) {
        return i_maxSupply;
    }

    /**
     * @notice Returns the current royalty percentage for the NFT.
     * @return The current royalty percentage.
     */
    function getRoyaltyPercentage() external view returns (uint96) {
        return s_royaltyPercentage;
    }

    /**
     * @notice Returns the base URI for the NFT metadata.
     * @return The base URI for the NFT metadata.
     */
    function getBaseURI() external view returns (string memory) {
        return s_baseURI;
    }

    ////////////////////////////////////////////////////////////////
    // The following functions are overrides required by Solidity //
    ////////////////////////////////////////////////////////////////
    /**
     * @dev Internal function to override the base URI for token metadata.
     * @return The overridden base URI.
     */
    function _baseURI() internal view override returns (string memory) {
        return s_baseURI;
    }

    /**
     * @dev Internal function to override the default implementation of the `_update` function.
     * @param to The address to transfer the token to.
     * @param tokenId The ID of the token to transfer.
     * @param auth The authorization address.
     * @return The address of the new owner.
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
     * @dev Internal function to override the default implementation of the `_increaseBalance` function.
     * @param account The account to increase the balance of.
     * @param value The amount to increase the balance by.
     */
    function _increaseBalance(address account, uint128 value) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    /**
     * @dev Internal function to override the default implementation of the `tokenURI` function.
     * @param tokenId The ID of the token.
     * @return The URI for the token metadata.
     */
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev Internal function to override the default implementation of the `supportsInterface` function.
     * @param interfaceId The ID of the interface to check support for.
     * @return Whether the contract supports the specified interface.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC2981, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
