// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title FactoryNFTContract
 * @author Shawn Rizo
 * @notice A factory contract for creating and managing NFT collections, with fee management and reentrancy protection.
 * @dev This contract allows for the creation and management of NFT collections. It utilizes the NFTContract for
 * individual collections, ensuring ownership and reentrancy protection. The contract allows for fee setting for
 * collection creation, withdrawal of accumulated fees, and querying of created collections.
 */
import { NFTContract } from "./NFTContract.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract FactoryNFTContract is Ownable, ReentrancyGuard {
    error FactoryNFTContract__InsufficientFunds();

    //////////////////////
    // State Variables  //
    //////////////////////
    address[] private s_collections; // Stores addresses of all created NFT collections.
    uint256 private s_fee; // Fee required to create a new NFT collection.

    //////////////
    // Events   //
    //////////////
    event CollectionCreated(
        address indexed collectionAddress,
        string indexed name,
        string indexed symbol,
        uint256 maxSupply,
        address owner,
        uint96 royaltyPercentage,
        uint256 mintPrice
    );

    //////////////////
    // Functions    //
    //////////////////
    /**
     * @dev Initializes the contract by setting the initial owner.
     * @param initialOwner The address to be set as the initial owner of the contract.
     */
    constructor(address initialOwner) Ownable(initialOwner) { }

    /////////////////////////////////
    // External/Public Functions   //
    /////////////////////////////////
    /**
     * @notice Allows for the creation of a new NFT collection with specified parameters.
     * @dev Creates a new NFT collection by deploying a new NFTContract. Requires payment of a fee set by the contract
     * owner.
     * @param name Name of the NFT collection.
     * @param symbol Symbol of the NFT collection.
     * @param baseURI Base URI for the NFT collection's metadata.
     * @param maxSupply Maximum number of NFTs that can be minted in the collection.
     * @param owner Address that will own the created NFT collection.
     * @param royaltyPercentage Royalty percentage for secondary sales.
     * @param mintPrice Price for minting an NFT in the collection.
     * @custom:reverts FactoryNFTContract__InsufficientFunds if the sent value is less than the required fee.
     */
    function createCollection(
        string memory name,
        string memory symbol,
        string memory baseURI,
        uint256 maxSupply,
        address owner,
        uint96 royaltyPercentage,
        uint256 mintPrice
    )
        external
        payable
        nonReentrant
    {
        if (msg.value < s_fee) {
            revert FactoryNFTContract__InsufficientFunds();
        }
        NFTContract newCollection =
            new NFTContract(name, symbol, baseURI, maxSupply, owner, royaltyPercentage, mintPrice);
        s_collections.push(address(newCollection));
        emit CollectionCreated(address(newCollection), name, symbol, maxSupply, owner, royaltyPercentage, mintPrice);
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
            revert FactoryNFTContract__InsufficientFunds();
        }
        payable(owner()).transfer(address(this).balance);
    }

    //////////////////////////////////////
    // Public/External View Functions   //
    //////////////////////////////////////
    /**
     * @notice Returns the addresses of all created NFT collections.
     * @dev Provides a view function to list all NFT collection addresses stored in the contract.
     * @return An array of addresses representing the NFT collections created through this contract.
     */
    function getCollections() external view returns (address[] memory) {
        return s_collections;
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
