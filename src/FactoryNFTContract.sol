// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { NFTContract } from "./NFTContract.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract FactoryNFTContract is Ownable {
    address[] public collections;

    event CollectionCreated(
        address indexed collectionAddress, string indexed name, string indexed symbol, uint256 maxSupply, address owner
    );

    constructor(address initialOwner) Ownable(initialOwner) { }

    function createCollection(
        string memory name,
        string memory symbol,
        string memory s_baseURI,
        uint256 maxSupply,
        address owner
    )
        public
    {
        NFTContract newCollection = new NFTContract(name, symbol, s_baseURI, maxSupply, owner);
        collections.push(address(newCollection));
        emit CollectionCreated(address(newCollection), name, symbol, maxSupply, owner);
    }

    function getCollections() public view returns (address[] memory) {
        return collections;
    }
}
