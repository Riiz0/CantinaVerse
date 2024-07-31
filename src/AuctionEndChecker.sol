// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { MarketPlace } from "./MarketPlace.sol";

contract AuctionEndChecker {
    MarketPlace public immutable marketPlace;

    constructor(MarketPlace _marketPlace) {
        marketPlace = _marketPlace;
    }

    function checker() external view returns (bool canExec, bytes memory execPayload) {
        // Example condition: Check if the auction has ended
        bool auctionEnded = marketPlace.auctionHasEnded();
        canExec = !auctionEnded;

        // Prepare the payload for the endAuction function
        execPayload = abi.encodeWithSignature("endAuction(uint256)", auctionId);
    }
}
