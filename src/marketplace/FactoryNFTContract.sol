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
     * @notice Returns the addresses of all created NFT collections.
     * @dev Provides a view function to list all NFT collection addresses stored in the contract.
     * @return An array of addresses representing the NFT collections created through this contract.
     */
    function getCollections() external view returns (address[] memory) {
        return s_collections;
    }

    /**
     * @param collectionAddress The address of the NFT collection.
     * @notice Returns the details of the specified NFT collection.
     * @return name The name of the NFT collection.
     * @return symbol The symbol of the NFT collection.
     * @return maxSupply The maximum number of NFTs that can be minted in the collection.
     * @return owner The owner of the NFT collection.
     * @return royaltyPercentage The royalty percentage for secondary sales.
     * @return mintPrice The price for minting an NFT in the collection.
     */
    function getCollectionDetails(address collectionAddress)
        external
        view
        returns (
            string memory name,
            string memory symbol,
            uint256 maxSupply,
            address owner,
            uint96 royaltyPercentage,
            uint256 mintPrice
        )
    {
        NFTContract collection = NFTContract(collectionAddress);
        return (
            collection.name(),
            collection.symbol(),
            collection.getMaxSupply(),
            collection.owner(),
            collection.getRoyaltyPercentage(),
            collection.getMintPrice()
        );
    }

    /**
     * @notice Returns the number of created NFT collections.
     * @return The number of created NFT collections.
     */
    function getCollectionCount() external view returns (uint256) {
        return s_collections.length;
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
