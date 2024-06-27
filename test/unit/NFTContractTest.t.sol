// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Test, console2, Vm } from "forge-std/Test.sol";
import { NFTContract } from "../../src/NFTContract.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { MockERC721 } from "../mocks/MockERC721.sol";
import { ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFTContractTest is Test {
    NFTContract nftcontract;
    HelperConfig config;

    event NewTokenMinted(address indexed to, uint256 indexed tokenId, string uri);
    event RoyaltyInfoUpdated(address recipient, uint96 feeNumerator);

    address MINTER = makeAddr("Minter");
    string name = "MY NFT COLLECTION";
    string symbol = "MYCOL";
    string baseURI = "ipfs://";
    uint256 maxSupply = 10;
    uint96 royaltyPercentage = 2500;
    uint256 INITIAL_STARTING_BALABCE = 100 ether;

    function setUp() public {
        config = new HelperConfig();
        nftcontract = new NFTContract(name, symbol, baseURI, maxSupply, address(config), royaltyPercentage);
        vm.deal(MINTER, INITIAL_STARTING_BALABCE);
    }

    modifier SafeMintRevert() {
        vm.startPrank(MINTER);
        nftcontract.safeMint(MINTER, "tokenURI"); //token(0)
        nftcontract.safeMint(MINTER, "tokenURI"); //token(1)
        nftcontract.safeMint(MINTER, "tokenURI"); //token(2)
        nftcontract.safeMint(MINTER, "tokenURI"); //token(3)
        nftcontract.safeMint(MINTER, "tokenURI"); //token(4)
        nftcontract.safeMint(MINTER, "tokenURI"); //token(5)
        nftcontract.safeMint(MINTER, "tokenURI"); //token(6)
        nftcontract.safeMint(MINTER, "tokenURI"); //token(7)
        nftcontract.safeMint(MINTER, "tokenURI"); //token(8)
        nftcontract.safeMint(MINTER, "tokenURI"); //token(9)
        nftcontract.safeMint(MINTER, "tokenURI"); //token(10)
        vm.stopPrank();
        _;
    }

    function testsafeMintRevertNFTContractMaxSupplyReached() public SafeMintRevert {
        vm.startPrank(MINTER);
        vm.expectRevert(NFTContract.NFTContract__MaxSupplyReached.selector);
        nftcontract.safeMint(MINTER, "tokenURI");
        vm.stopPrank();
    }

    function test_ExpectEmit_EventNewTokenMinted() public {
        vm.startPrank(MINTER);
        vm.expectEmit(true, true, true, false);
        emit NewTokenMinted(address(MINTER), 0, "tokenURI");
        nftcontract.safeMint(MINTER, "tokenURI");
        vm.stopPrank();
    }

    function testGetMaxSupply() public SafeMintRevert {
        assertEq(nftcontract.getMaxSupply(), 10);
    }

    function testUpdateRoyaltyInfo() public SafeMintRevert {
        uint96 newRoyaltyPercentage = 3000;

        vm.startPrank(address(config));
        assertEq(nftcontract.getRoyaltyPercentage(), royaltyPercentage);
        nftcontract.updateRoyaltyInfo(address(config), newRoyaltyPercentage);
        assertEq(nftcontract.getRoyaltyPercentage(), newRoyaltyPercentage);
        vm.stopPrank();
    }

    function testRevertNFTContractMaxRoyaltyPercentageReached() public SafeMintRevert {
        uint96 newRoyaltyPercentage = 3100;

        vm.startPrank(address(config));
        assertEq(nftcontract.getRoyaltyPercentage(), royaltyPercentage);
        vm.expectRevert(NFTContract.NFTContract__MaxRoyaltyPercentageReached.selector);
        nftcontract.updateRoyaltyInfo(address(config), newRoyaltyPercentage);
        vm.stopPrank();
    }

    function test_ExpectEmit_EventRoyaltyInfoUpdated() public SafeMintRevert {
        uint96 newRoyaltyPercentage = 1500;
        vm.startPrank(address(config));

        vm.expectEmit(true, true, false, false);
        emit RoyaltyInfoUpdated(address(config), newRoyaltyPercentage);
        nftcontract.updateRoyaltyInfo(address(config), newRoyaltyPercentage);
        vm.stopPrank();
    }

    function testSetBaseURI() public SafeMintRevert {
        string memory newBaseURI = "https://";
        vm.startPrank(address(config));
        assertEq(nftcontract.getBaseURI(), baseURI);
        nftcontract.setBaseURI(newBaseURI);
        assertEq(nftcontract.getBaseURI(), newBaseURI);
        vm.stopPrank();
    }

    function testTokenURI() public SafeMintRevert {
        uint256 tokenId = 1; // Assuming this token ID exists
        string memory expectedTokenURI = string(abi.encodePacked(baseURI, "tokenURI"));
        assertEq(nftcontract.tokenURI(tokenId), expectedTokenURI);
    }

    function testSupportsInterface() public view {
        bytes4 interfaceIdERC721 = 0x80ac58cd; // ERC721 interface ID
        assertTrue(nftcontract.supportsInterface(interfaceIdERC721), "Should support ERC721 interface.");

        bytes4 interfaceIdERC2981 = 0x2a55205a; // ERC2981 interface ID
        assertTrue(nftcontract.supportsInterface(interfaceIdERC2981), "Should support ERC2981 interface.");

        // Add more interface IDs as needed
    }
}
