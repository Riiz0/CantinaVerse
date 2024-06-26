// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { NFTContract } from "./NFTContract.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract FactoryNFTContract is Ownable {
    error FactoryNFTContract__InvalidInitialOwner();

    address[] private collections;

    event CollectionCreated(
        address indexed collectionAddress,
        string indexed name,
        string indexed symbol,
        uint256 maxSupply,
        address owner,
        uint256 royaltyPercentage
    );

    constructor(address initialOwner) Ownable(initialOwner) {
        if (initialOwner == address(0)) {
            revert FactoryNFTContract__InvalidInitialOwner();
        }
    }

    function createCollection(
        string memory name,
        string memory symbol,
        string memory s_baseURI,
        uint256 maxSupply,
        address owner,
        uint256 royaltyPercentage
    )
        external
    {
        NFTContract newCollection = new NFTContract(name, symbol, s_baseURI, maxSupply, owner, royaltyPercentage);
        collections.push(address(newCollection));
        emit CollectionCreated(address(newCollection), name, symbol, maxSupply, owner, royaltyPercentage);
    }

    function getCollections() public view returns (address[] memory) {
        return collections;
    }
}
