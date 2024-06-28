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
    HelperConfig helperConfig;

    /**
     * @dev Initializes the DeployMarketPlace with the address of the HelperConfig contract.
     * @param helperConfigAddress The address of the HelperConfig contract.
     */
    constructor(address helperConfigAddress) {
        helperConfig = HelperConfig(helperConfigAddress);
    }

    /**
     * @notice Deploys the MarketPlace contract with the active network configuration.
     * @dev Fetches the active network configuration from the HelperConfig contract and uses it to deploy the
     * MarketPlace contract.
     * @return The address of the newly deployed MarketPlace contract.
     */
    function run() external returns (MarketPlace) {
        HelperConfig.NetworkConfig memory config = helperConfig.getActiveNetworkConfig();

        MarketPlace marketPlace = new MarketPlace(config.initialOwner);

        return marketPlace;
    }

    /**
     * @notice Returns the HelperConfig contract used by this script.
     * @return The HelperConfig contract.
     */
    function getHelperConfig() public view returns (HelperConfig) {
        return helperConfig;
    }
}
