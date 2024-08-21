// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { IMarketPlace } from "./interfaces/IMarketPlace.sol";

contract AuctionEndChecker {
    IMarketPlace public immutable marketPlace;

    constructor(IMarketPlace _marketPlace) {
        marketPlace = _marketPlace;
    }

    function checker() external view returns (bool canExec, bytes memory execPayload) {
        for (uint256 i = 0; i < marketPlace.auctionIdsLength(); i++) {
            (
                , // seller
                , // highestBidder
                , // nftAddress
                , // tokenId
                , // startingPrice
                , // highestBid
                , // startTime
                uint256 endTime
            ) = marketPlace.getAuction(i);
            if (block.timestamp >= endTime) {
                return (true, abi.encodeWithSignature("endAuction(uint256)", i));
            }
        }

        return (false, "");
    }
}
