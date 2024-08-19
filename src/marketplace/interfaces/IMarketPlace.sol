// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { MarketPlace } from "../MarketPlace.sol";

interface IMarketPlace {
    function auctionIdsLength() external view returns (uint256);
    function getAuction(
        uint256 auctionId
    )
        external
        view
        returns (
            address seller,
            address highestBidder,
            address nftAddress,
            uint256 tokenId,
            uint256 startingPrice,
            uint256 highestBid,
            uint256 startTime,
            uint256 endTime
        );
}
