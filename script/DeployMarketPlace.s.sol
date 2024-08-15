// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title DeployMarketPlace
 * @author Shawn Rizo
 * @notice A script to deploy the MarketPlace contract with configurations fetched from a HelperConfig contract.
 */
import { Script, console2 } from "forge-std/Script.sol";
import { MarketPlace } from "../src/MarketPlace.sol";
import { HelperConfig } from "./HelperConfig.s.sol";

contract DeployMarketPlace is Script {
    /**
     * @notice Deploys the MarketPlace contract with the active network configuration.
     * @dev Fetches the active network configuration from the HelperConfig contract and uses it to deploy the
     * MarketPlace contract.
     * @return The address of the newly deployed MarketPlace contract.
     */
    function run() external returns (MarketPlace, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getOrCreateAnvilEthConfig();

        MarketPlace marketPlace = new MarketPlace(config.initialOwner, config.initialGelatoAddress, 0);

        return (marketPlace, helperConfig);
    }
}
