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
    uint256 private s_nextTokenId;
    string private s_baseURI;
    uint256 public s_maxSupply;

    //////////////
    // Events   //
    //////////////
    event NewTokenMinted(address indexed to, uint256 indexed tokenId, string uri);

    //////////////////
    // Functions    //
    //////////////////
    constructor(
        string memory name,
        string memory symbol,
        string memory baseURI,
        uint256 _maxSupply,
        address initialOwner
    )
        ERC721(name, symbol)
        Ownable(initialOwner)
    {
        s_baseURI = baseURI;
        s_maxSupply = _maxSupply;
    }

    /////////////////////////////////
    // External/Public Functions   //
    /////////////////////////////////

    /**
     *
     * @param to is the address of the account that will receive the NFT.
     * @param uri is the URI of the NFT.
     * @notice This function will mint a new NFT and assign it to the address provided.
     */
    function safeMint(address to, string memory uri) public {
        uint256 tokenId = s_nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        emit NewTokenMinted(to, tokenId, uri);
    }

    // The following functions are overrides required by Solidity.
    function _baseURI() internal view override returns (string memory) {
        return s_baseURI;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        s_baseURI = baseURI;
    }

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
