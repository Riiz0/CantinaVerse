// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title DeployFactoryNFTContract
 * @author Shawn Rizo
 * @notice A script to deploy the FactoryNFTContract with configurations fetched from a HelperConfig contract.
 */
import { Script, console2 } from "forge-std/Script.sol";
import { HelperConfig } from "./HelperConfig.s.sol";
import { FactoryNFTContract } from "../../../src/marketplace/FactoryNFTContract.sol";

contract DeployFactoryNFTContract is Script {
    /**
     * @notice Deploys the FactoryNFTContract with the active network configuration.
     * @dev Fetches the active network configuration from the HelperConfig contract and uses it to deploy the
     * FactoryNFTContract.
     * @return The address of the newly deployed FactoryNFTContract.
     */
    function run() external returns (FactoryNFTContract) {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config;

        if (block.chainid == 31_337) {
            config = helperConfig.getAnvilConfig();
        } else if (block.chainid == 11_155_111) {
            config = helperConfig.getSepoliaConfig();
        } else if (block.chainid == 8453) {
            config = helperConfig.getBaseMainnetConfig();
        } else if (block.chainid == 10) {
            config = helperConfig.getOpMainnetConfig();
        } else if (block.chainid == 34_443) {
            config = helperConfig.getModeMainnetConfig();
        } else {
            revert("Unsupported network");
        }

        vm.startBroadcast();
        FactoryNFTContract factory = new FactoryNFTContract(config.initialOwner, config.serviceFee);
        vm.stopBroadcast();

        console2.log("FactoryNFTContract deployed at:", address(factory));
        console2.log("Initial owner:", config.initialOwner);
        console2.log("Service fee:", config.serviceFee);

        return factory;
    }
}
