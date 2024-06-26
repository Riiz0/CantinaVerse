// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MockERC721 is ERC721 {
    uint256 private _totalSupply;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        _totalSupply = 0;
    }

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
        _totalSupply += 1;
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        super.transferFrom(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) public override {
        super.approve(to, tokenId);
    }

    function burn(uint256 tokenId) public {
        super._burn(tokenId);
        _totalSupply -= 1;
    }

    function ownerOf(uint256 tokenId) public view override returns (address) {
        return super.ownerOf(tokenId);
    }

    function balanceOf(address owner) public view override returns (uint256) {
        return super.balanceOf(owner);
    }

    // Corrected the totalSupply function to call the base contract's totalSupply
    function getTotalSupply() public view returns (uint256) {
        return _totalSupply;
    }
}
