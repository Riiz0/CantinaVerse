// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Script, console2 } from "forge-std/Script.sol";
import { HelperConfig } from "./HelperConfig.s.sol";
import { FactoryNFTContract } from "../src/FactoryNFTContract.sol";

contract DeployFactoryNFTContract is Script {
    HelperConfig helperConfig;

    constructor(address helperConfigAddress) {
        helperConfig = HelperConfig(helperConfigAddress);
    }

    function run() external returns (FactoryNFTContract) {
        HelperConfig.NetworkConfig memory config = helperConfig.getActiveNetworkConfig();

        FactoryNFTContract factory = new FactoryNFTContract(config.initialOwner);

        return factory;
    }

    function getHelperConfig() public view returns (HelperConfig) {
        return helperConfig;
    }
}
