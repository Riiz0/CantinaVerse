// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

/**
 * @title NFTContract
 * @author Shawn Rizo
 * @notice This contract will be responsible for the creation, ownership, and transfer of NFTs.
 * It will implement the ERC-721 standard, which is the core standard for NFTs on Ethereum or any EVM Compatible Chain.
 * This contract will handle the minting of new NFTs, the transfer of ownership, and the approval of NFTs for trading.
 */
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract NFTContract is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    //////////////////////
    // State Variables  //
    //////////////////////
    uint256 private _nextTokenId;

    //////////////
    // Events   //
    //////////////
    event NewTokenMinted(address indexed to, uint256 indexed tokenId, string uri);

    //////////////////
    // Functions    //
    //////////////////
    constructor(address initialOwner) ERC721("NFTContract", "NFTC") Ownable(initialOwner) { }

    /////////////////////////////////
    // External/Public Functions   //
    /////////////////////////////////

    /**
     *
     * @param to is the address of the account that will receive the NFT.
     * @param uri is the URI of the NFT.
     * @notice This function will mint a new NFT and assign it to the address provided.
     */
    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        emit NewTokenMinted(to, tokenId, uri);
    }

    // The following functions are overrides required by Solidity.
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

    function _increaseBalance(address account, uint128 value) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
