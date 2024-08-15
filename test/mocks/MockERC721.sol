// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title MockERC721
 * @dev Simple ERC721 Token example, with mintable functionality.
 */
contract MockERC721 is ERC721 {
    uint256 private _tokenIdCounter;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) { }

    /**
     * @dev Mints a new token to the specified address.
     * @param to The address that will own the minted token.
     */
    function safeMint(address to) public {
        _safeMint(to, _tokenIdCounter);
        _tokenIdCounter++;
    }

    /**
     * @dev Returns the current token ID counter value.
     * This can be used to know how many tokens have been minted.
     */
    function getCurrentTokenId() public view returns (uint256) {
        return _tokenIdCounter;
    }

    function getTotalSupply() public view returns (uint256) {
        return _tokenIdCounter;
    }
}
