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
    error FactoryNFTContract__CantBeZeroAddress();
    error FactoryNFTContract__CantBeZeroAmount();
    error FactoryNFTContract__TransferFailed();
    error FactoryNFTContract__IndexOutOfBounds();

    //////////////////////
    // State Variables  //
    //////////////////////
    struct NFTCollection {
        address collectionAddress;
        string name;
        string symbol;
        uint256 maxSupply;
        address owner;
        uint96 royaltyPercentage;
        uint256 mintPrice;
    }

    NFTCollection[] private s_collectionsDetails; // Stores details of all created NFT collections.
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
    constructor(address initialOwner, uint256 _sFee) Ownable(initialOwner) {
        s_fee = _sFee;
    }

    /////////////////////////////////
    // External/Public Functions   //
    /////////////////////////////////
    /**
     * @notice Allows for the creation of a new NFT collection with specified parameters.
     * @dev Creates a new NFT collection by deploying a new NFTContract. Requires payment of a fee set by the contract
     * owner.
     * @param name Name of the NFT collection.
     * @param symbol Symbol of the NFT collection.
     * @param maxSupply Maximum number of NFTs that can be minted in the collection.
     * @param owner Address that will own the created NFT collection.
     * @param royaltyPercentage Royalty percentage for secondary sales.
     * @param mintPrice Price for minting an NFT in the collection.
     * @custom:reverts FactoryNFTContract__InsufficientFunds if the sent value is less than the required fee.
     */
    function createCollection(
        string memory name,
        string memory symbol,
        uint256 maxSupply,
        address owner,
        uint96 royaltyPercentage,
        uint256 mintPrice
    )
        external
        payable
        nonReentrant
    {
        if (msg.value != s_fee) {
            revert FactoryNFTContract__InsufficientFunds();
        }
        NFTContract newCollection = new NFTContract(name, symbol, maxSupply, msg.sender, royaltyPercentage, mintPrice);
        s_collections.push(address(newCollection));
        s_collectionsDetails.push(
            NFTCollection({
                collectionAddress: address(newCollection),
                name: name,
                symbol: symbol,
                maxSupply: maxSupply,
                owner: msg.sender, // The address that deployed the collection
                royaltyPercentage: royaltyPercentage,
                mintPrice: mintPrice
            })
        );
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
     * @param recipient The address of the recipient.
     * @param amount The amount to be withdrawn.
     * @dev Withdraws the specified amount from the contract. Can only be called by the contract owner.
     * @notice Withdraws the specified amount from the contract.
     */
    function withdraw(address payable recipient, uint256 amount) external onlyOwner {
        if (recipient == address(0)) {
            revert FactoryNFTContract__CantBeZeroAddress();
        }
        if (amount == 0) {
            revert FactoryNFTContract__CantBeZeroAmount();
        }

        (bool success,) = recipient.call{ value: amount }("");
        if (!success) revert FactoryNFTContract__TransferFailed();
    }

    //////////////////////////////////////
    // Public/External View Functions   //
    //////////////////////////////////////
    /**
     * @notice Returns the details of all created NFT collections.
     * @dev Provides a view function to see the details of all created NFT collections.
     * @return The details of all created NFT collections.
     */
    function getAllCollections() external view returns (NFTCollection[] memory) {
        return s_collectionsDetails;
    }

    /**
     * @param index The index of the NFT collection.
     * @notice Returns the details of the specified NFT collection.
     * @dev Provides a view function to see the details of the specified NFT collection.
     * @return The details of the specified NFT collection.
     */
    function getCollectionDetails(uint256 index) external view returns (NFTCollection memory) {
        if (index >= s_collectionsDetails.length) {
            revert FactoryNFTContract__IndexOutOfBounds();
        }
        return s_collectionsDetails[index];
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
