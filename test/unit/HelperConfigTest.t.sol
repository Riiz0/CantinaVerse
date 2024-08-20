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

    function testgetAnvilConfig() public view {
        // First call to set the localNetworkConfig
        helperConfig.getAnvilConfig();
        // Second call to check if it returns the already set config
        HelperConfig.NetworkConfig memory config = helperConfig.getAnvilConfig();
        assertEq(config.initialOwner, address(1)); // Assuming address(1) is the expected owner after creation
    }
}
