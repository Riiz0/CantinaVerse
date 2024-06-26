// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Script, console2 } from "forge-std/Script.sol";
import { MarketPlace } from "../src/MarketPlace.sol";
import { HelperConfig } from "./HelperConfig.s.sol";

contract DeployMarketPlace is Script {
    HelperConfig helperConfig;

    constructor(address helperConfigAddress) {
        helperConfig = HelperConfig(helperConfigAddress);
    }

    function run() external returns (MarketPlace) {
        HelperConfig.NetworkConfig memory config = helperConfig.getActiveNetworkConfig();

        MarketPlace marketPlace = new MarketPlace(config.initialOwner);

        return marketPlace;
    }

    function getHelperConfig() public view returns (HelperConfig) {
        return helperConfig;
    }
}
