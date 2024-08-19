// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Test, console2, Vm } from "forge-std/Test.sol";
import { NFTContract } from "../../src/marketplace/NFTContract.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { MockERC721 } from "../mocks/MockERC721.sol";
import { ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFTContractTest is Test {
    NFTContract nftcontract;
    NFTContract nftcontract2;
    NFTContract nftcontract3;

    event NewTokenMinted(address indexed to, uint256 indexed tokenId, string indexed uri, uint256 mintPrice);
    event RoyaltyInfoUpdated(address indexed recipient, uint96 indexed feeNumerator);

    address MINTER = makeAddr("Minter");
    address OWNER = makeAddr("Owner");
    string name = "MY NFT COLLECTION";
    string symbol = "MYCOL";
    string baseURI = "ipfs://";
    uint256 maxSupply = 10;
    uint96 royaltyPercentage = 2500;
    uint256 INITIAL_STARTING_BALABCE = 100 ether;
    uint256 mintPrice = 0 ether;
    uint256 mintTestPrice = 0.01 ether;

    function setUp() public {
        nftcontract = new NFTContract(name, symbol, baseURI, maxSupply, OWNER, royaltyPercentage, mintPrice);
        nftcontract2 = new NFTContract(name, symbol, baseURI, maxSupply, OWNER, royaltyPercentage, mintTestPrice);
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

    function testConstructorRevertMaxRoyaltyPercentageReached() public {
        // Define a royalty percentage that exceeds the maximum allowed
        uint96 excessiveRoyaltyPercentage = 10_001; // Assuming MAX_ROYALTY_PERCENTAGE is 10000 (100%)

        // Expect the contract deployment to revert with the specific error
        vm.expectRevert(NFTContract.NFTContract__MaxRoyaltyPercentageReached.selector);

        // Attempt to deploy the contract with the excessive royalty percentage
        new NFTContract(name, symbol, baseURI, maxSupply, msg.sender, excessiveRoyaltyPercentage, mintPrice);
    }

    function testRevert_InsufficientFunds() public {
        vm.prank(MINTER);
        vm.expectRevert(NFTContract.NFTContract__InsufficientFunds.selector);
        nftcontract2.safeMint{ value: 0.005 ether }(MINTER, "tokenURI");
    }

    function testTransferMintingFeeToOwnerWithFixedMintPrice() public {
        uint256 initialOwnerBalance = OWNER.balance;
        assertEq(initialOwnerBalance, 0, "Owner should have the initial balance");

        vm.startPrank(MINTER);
        // Directly use the fixed mint price set during contract initialization
        nftcontract2.safeMint{ value: mintTestPrice }(MINTER, "tokenURI1");
        nftcontract2.safeMint{ value: mintTestPrice }(MINTER, "tokenURI2");
        vm.stopPrank();

        // After minting, check the owner's balance to see if it has been updated correctly
        uint256 finalOwnerBalance = OWNER.balance;
        // Calculate the expected balance increase considering the mint price
        uint256 expectedBalanceIncrease = (2 * mintTestPrice); // Since the entire mintTestPrice is sent with each mint
        assertEq(
            finalOwnerBalance, initialOwnerBalance + expectedBalanceIncrease, "Owner should receive the minting fees"
        );
    }

    function testFreeMintingWithZeroMintPrice() public {
        uint256 initialOwnerBalance = OWNER.balance;
        assertEq(initialOwnerBalance, 0, "Owner should have the initial balance");

        vm.startPrank(MINTER);
        // Call safeMint with no value sent, assuming the mint price is set to zero
        nftcontract.safeMint(MINTER, "tokenURI1");
        vm.stopPrank();

        // After minting, check the owner's balance to see if it remains unchanged
        uint256 finalOwnerBalance = OWNER.balance;
        assertEq(finalOwnerBalance, initialOwnerBalance, "Owner should not receive any fees for free minting");
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
        emit NewTokenMinted(address(MINTER), 0, "tokenURI", mintPrice);
        nftcontract.safeMint(MINTER, "tokenURI");
        vm.stopPrank();
    }

    function testGetMaxSupply() public SafeMintRevert {
        assertEq(nftcontract.getMaxSupply(), 10);
    }

    function testUpdateRoyaltyInfo() public SafeMintRevert {
        uint96 newRoyaltyPercentage = 3000;

        vm.startPrank(OWNER);
        assertEq(nftcontract.getRoyaltyPercentage(), royaltyPercentage);
        nftcontract.updateRoyaltyInfo(OWNER, newRoyaltyPercentage);
        assertEq(nftcontract.getRoyaltyPercentage(), newRoyaltyPercentage);
        vm.stopPrank();
    }

    function testGetMintPrice() public view {
        assertEq(nftcontract.getMintPrice(), mintPrice);
    }

    function testRevertNFTContractMaxRoyaltyPercentageReached() public SafeMintRevert {
        uint96 newRoyaltyPercentage = 3100;

        vm.startPrank(OWNER);
        assertEq(nftcontract.getRoyaltyPercentage(), royaltyPercentage);
        vm.expectRevert(NFTContract.NFTContract__MaxRoyaltyPercentageReached.selector);
        nftcontract.updateRoyaltyInfo(OWNER, newRoyaltyPercentage);
        vm.stopPrank();
    }

    function test_ExpectEmit_EventRoyaltyInfoUpdated() public SafeMintRevert {
        uint96 newRoyaltyPercentage = 1500;
        vm.startPrank(OWNER);

        vm.expectEmit(true, true, false, false);
        emit RoyaltyInfoUpdated(OWNER, newRoyaltyPercentage);
        nftcontract.updateRoyaltyInfo(OWNER, newRoyaltyPercentage);
        vm.stopPrank();
    }

    function testSetBaseURI() public SafeMintRevert {
        string memory newBaseURI = "https://";
        vm.startPrank(OWNER);
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
    }
}
