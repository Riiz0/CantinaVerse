// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Test, console2, Vm } from "forge-std/Test.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";

contract HelperConfigTest is Test {
    HelperConfig helperConfig;
    address helperConfigAddress;

    function setUp() public {
        helperConfig = new HelperConfig();
        helperConfigAddress = address(helperConfig);
    }

    function testGetConfigByChainIdWithUnsetChain() public {
        HelperConfig.NetworkConfig memory config = helperConfig.getConfigByChainId(0); // Use an unset chain ID
        assertEq(config.initialOwner, address(1)); // Assuming address(1) is the fallback owner
    }

    function testGetOrCreateAnvilEthConfigAlreadySet() public {
        // First call to set the localNetworkConfig
        helperConfig.getOrCreateAnvilEthConfig();
        // Second call to check if it returns the already set config
        HelperConfig.NetworkConfig memory config = helperConfig.getOrCreateAnvilEthConfig();
        assertEq(config.initialOwner, address(1)); // Assuming address(1) is the expected owner after creation
    }

    function testGetConfigByChainIdWithSetChain() public {
        // Use a predefined chain ID for which the config is set in the constructor
        uint256 chainId = 11_155_111;
        HelperConfig.NetworkConfig memory config = helperConfig.getConfigByChainId(chainId);
        // Verify that the returned config matches the expected initialOwner set in the constructor
        assertEq(
            config.initialOwner,
            address(0xfe63Ba8189215E5C975e73643b96066B6aD41A45),
            "The initialOwner should be address(1) for predefined chain IDs"
        );
    }
}
