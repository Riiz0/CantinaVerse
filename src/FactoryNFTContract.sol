// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title FactoryNFTContract
 * @author Shawn Rizo
 * @notice A factory contract for creating and managing NFT collections.
 */
import { NFTContract } from "./NFTContract.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract FactoryNFTContract is Ownable {
    //////////////////////
    // State Variables  //
    //////////////////////
    address[] private collections;

    //////////////
    // Events   //
    //////////////
    event CollectionCreated(
        address indexed collectionAddress,
        string indexed name,
        string indexed symbol,
        uint256 maxSupply,
        address owner,
        uint96 royaltyPercentage
    );

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
     * @notice Creates a new NFT collection.
     * @dev Deploys a new instance of the NFTContract and adds its address to the collections array.
     * @param name The name of the new collection.
     * @param symbol The symbol of the new collection.
     * @param baseURI The base URI for the collection.
     * @param maxSupply The maximum supply of tokens in the collection.
     * @param owner The address of the collection owner.
     * @param royaltyPercentage The royalty percentage for the collection.
     */
    function createCollection(
        string memory name,
        string memory symbol,
        string memory baseURI,
        uint256 maxSupply,
        address owner,
        uint96 royaltyPercentage
    )
        external
    {
        NFTContract newCollection = new NFTContract(name, symbol, baseURI, maxSupply, owner, royaltyPercentage);
        collections.push(address(newCollection));
        emit CollectionCreated(address(newCollection), name, symbol, maxSupply, owner, royaltyPercentage);
    }

    //////////////////////////////////////
    // Public/External View Functions   //
    //////////////////////////////////////
    /**
     * @notice Returns an array of addresses representing all created NFT collections.
     * @return An array of addresses of created NFT collections.
     */
    function getCollections() external view returns (address[] memory) {
        return collections;
    }
}
